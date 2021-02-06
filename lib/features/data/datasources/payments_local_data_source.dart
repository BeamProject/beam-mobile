import 'package:beam/features/domain/entities/payment.dart';

abstract class PaymentsLocalDataSource {
  Stream<List<Payment>> getPayments();

  Future<void> setPayments(List<Payment> payments);

  Future<void> addPayment(Payment payment);
}