import 'package:beam/features/data/payment_repository_impl.dart';
import 'package:beam/features/domain/entities/payment.dart';

abstract class PaymentsLocalDataSource {
  Stream<TimestampedPayments> getPayments();

  Future<void> setPayments(TimestampedPayments timestampedPayments);

  Future<void> addPayment(Payment payment);
}