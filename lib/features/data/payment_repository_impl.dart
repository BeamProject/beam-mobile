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
    final s = _getPaymentsFromDataSources(userId);
    print("S is: $s");
    return Stream.fromFuture(s);
  }

  @override 
  Stream<List<Payment>> getPaymentsBetween(
      String userId, DateTime from, DateTime to) async* {
    final allPayments = await _getPaymentsFromDataSources(userId);
    yield* Stream.value(allPayments
        .where((payment) =>
            payment.transactionDate.toUtc().isAfter(from.toUtc()) &&
            payment.transactionDate.toUtc().isBefore(to.toUtc()))
        .toList());
  }

  Future<List<Payment>> _getPaymentsFromDataSources(String userId) {
    return ConcatStream([
      _paymentLocalDataSource.getPayments(),
      _paymentRemoteDataSource
          .getPayments(userId)
          .doOnEach((paymentsNofitication) {
        if (paymentsNofitication.kind == Kind.OnData) {
          print("Repo: Caching payments");
          _paymentLocalDataSource.setPayments(paymentsNofitication.requireData);
        }
      })
    ]).first;
  }
}
