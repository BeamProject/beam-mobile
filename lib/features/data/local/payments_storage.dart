import 'package:beam/features/data/datasources/payments_local_data_source.dart';
import 'package:beam/features/data/payment_repository_impl.dart';
import 'package:beam/features/domain/entities/payment.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PaymentsStorage implements PaymentsLocalDataSource {
  // TODO: Change to a DB
  TimestampedPayments _dummyCacheFixMe = TimestampedPayments([
    Payment(
        id: "4",
        userId: "1",
        currency: "USD",
        amount: 6,
        transactionDate: DateTime.utc(2021, 06, 13)),
    Payment(
        id: "5",
        userId: "1",
        currency: "USD",
        amount: 2,
        transactionDate: DateTime.utc(2021, 06, 15)),
    Payment(
        id: "1",
        userId: "1",
        currency: "USD",
        amount: 20,
        transactionDate: DateTime.utc(2021, 06, 05)),
    Payment(
        id: "2",
        userId: "1",
        currency: "USD",
        amount: 10,
        transactionDate: DateTime.utc(2021, 06, 04)),
    Payment(
        id: "3",
        userId: "1",
        currency: "USD",
        amount: 3,
        transactionDate: DateTime.utc(2021, 04, 07)),
    Payment(
        id: "4",
        userId: "1",
        currency: "USD",
        amount: 6,
        transactionDate: DateTime.utc(2021, 02, 21)),
    Payment(
        id: "4",
        userId: "1",
        currency: "USD",
        amount: 6,
        transactionDate: DateTime.utc(2021, 03, 21)),
    Payment(
        id: "5",
        userId: "1",
        currency: "USD",
        amount: 2,
        transactionDate: DateTime.utc(2021, 05, 15)),
  ], DateTime.utc(2021, 06, 19, 14).millisecondsSinceEpoch);

  // This method might not be necessary if we have setPayments.
  @override
  Future<void> addPayment(Payment payment) async {
    _dummyCacheFixMe.payments.add(payment);
  }

  @override
  Stream<TimestampedPayments> getPayments() async* {
    if (_dummyCacheFixMe.payments.isEmpty) {
      yield* Stream.empty();
    } else {
      yield _dummyCacheFixMe;
    }
  }

  @override
  Future<void> setPayments(TimestampedPayments payments) async {
    _dummyCacheFixMe = payments;
  }
}
