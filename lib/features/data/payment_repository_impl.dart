import 'dart:developer';

import 'package:beam/features/data/datasources/payments_local_data_source.dart';
import 'package:beam/features/data/datasources/payments_remote_data_source.dart';
import 'package:beam/features/domain/entities/payment.dart';
import 'package:beam/features/domain/entities/payment_request.dart';
import 'package:beam/features/domain/entities/payment_result.dart';
import 'package:beam/features/domain/repositories/payment_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class PaymentRepositoryImpl extends PaymentRepository {
  static const PAYMENT_STALE_MS = 15 * 1000;
  final PaymentsRemoteDataSource _paymentRemoteDataSource;
  final PaymentsLocalDataSource _paymentLocalDataSource;

  PaymentRepositoryImpl(
      this._paymentRemoteDataSource, this._paymentLocalDataSource);

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
      _paymentLocalDataSource.getPayments(),
      Stream.fromFuture(_paymentRemoteDataSource.getPayments(userId))
          .map((payments) => TimestampedPayments(
              payments, DateTime.now().millisecondsSinceEpoch))
          .doOnEach((paymentsNofitication) {
        if (paymentsNofitication.kind == Kind.OnData) {
          log("Repo: Caching payments: ${paymentsNofitication.requireData.payments}");
          _paymentLocalDataSource.setPayments(paymentsNofitication.requireData);
        }
      })
    ])
        .firstWhere((timestampedPayment) => timestampedPayment.isUpToDate())
        .then((timestampedPayment) => timestampedPayment.payments));
  }
}

class TimestampedPayments {
  final List<Payment> payments;
  final int timestamp;

  TimestampedPayments(this.payments, this.timestamp);

  bool isUpToDate() {
    return DateTime.now().millisecondsSinceEpoch - timestamp <=
        PaymentRepositoryImpl.PAYMENT_STALE_MS;
  }
}
