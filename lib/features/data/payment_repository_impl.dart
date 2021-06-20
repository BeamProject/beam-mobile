import 'dart:developer';

import 'package:beam/features/data/datasources/payments_local_data_source.dart';
import 'package:beam/features/data/datasources/payments_remote_data_source.dart';
import 'package:beam/features/domain/entities/payment.dart';
import 'package:beam/features/domain/entities/payment_request.dart';
import 'package:beam/features/domain/entities/payment_result.dart';
import 'package:beam/features/domain/repositories/payment_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class PaymentRepositoryImpl extends PaymentRepository {
  static const PAYMENT_STALE_MS = 10 * 60 * 1000; // 10 min
  final PaymentsRemoteDataSource _paymentRemoteDataSource;
  final PaymentsLocalDataSource _paymentLocalDataSource;
  final TimestampedPaymentsCache _diskCache;

  PaymentRepositoryImpl(
      this._paymentRemoteDataSource, this._paymentLocalDataSource)
      : _diskCache = TimestampedPaymentsCache(_paymentLocalDataSource);

  @override
  Future<PaymentResult> makeDelayedPayment(PaymentRequest paymentRequest) {
    return _paymentRemoteDataSource.makeDelayedPayment(paymentRequest);
  }

  @override
  Stream<List<Payment>> getPayments(String userId) {
    return _getPaymentsFromDataSources(userId);
  }

  @override
  Stream<List<Payment>> getPaymentsBetween(
      String userId, DateTime from, DateTime to) {
    final allPaymentsStream = _getPaymentsFromDataSources(userId);
    return allPaymentsStream.map((payments) => payments
        .where((payment) =>
            payment.transactionDate.toUtc().isAfter(from.toUtc()) &&
            payment.transactionDate.toUtc().isBefore(to.toUtc()))
        .toList());
  }

  Stream<List<Payment>> _getPaymentsFromDataSources(String userId) {
    return Stream.fromFuture(ConcatStream([
      _diskCache.getFromCache(false),
      FromCallableStream(() => _paymentRemoteDataSource.getPayments(userId))
          .map((payments) => TimestampedPayments(
              payments, DateTime.now().millisecondsSinceEpoch))
          .doOnEach((paymentsNofitication) {
        if (paymentsNofitication.kind == Kind.OnData) {
          log("Repo: Caching payments: ${paymentsNofitication.requireData.payments}");
          _paymentLocalDataSource.setPayments(paymentsNofitication.requireData);
        }
      }).onErrorResume((error, trace) => _diskCache
              .getFromCache(true)
              .take(1)
              .switchIfEmpty(Stream.error(error)))
    ]).first.then((timestampedPayment) => timestampedPayment.payments));
  }
}

class TimestampedPaymentsCache {
  final PaymentsLocalDataSource _paymentsLocalDataSource;

  TimestampedPaymentsCache(this._paymentsLocalDataSource);

  Stream<TimestampedPayments> getFromCache(bool ignoreStaleValue) async* {
    final timestampedPayments = await _paymentsLocalDataSource.getPayments();
    if (timestampedPayments.isUpToDate() || ignoreStaleValue) {
      yield* Stream.fromIterable([timestampedPayments]);
    } else {
      yield* Stream.empty();
    }
  }
}

class TimestampedPayments extends Equatable {
  final List<Payment> payments;
  final int timestamp;

  TimestampedPayments(this.payments, this.timestamp);

  bool isUpToDate() {
    return DateTime.now().millisecondsSinceEpoch - timestamp <=
        PaymentRepositoryImpl.PAYMENT_STALE_MS;
  }

  @override
  List<Object?> get props => [payments, timestamp];
}
