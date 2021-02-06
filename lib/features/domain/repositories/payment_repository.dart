import 'package:beam/features/domain/entities/payment.dart';
import 'package:beam/features/domain/entities/payment_request.dart';
import 'package:beam/features/domain/entities/payment_result.dart';

abstract class PaymentRepository {
  Future<PaymentResult> makeDelayedPayment(PaymentRequest paymentRequest);

  Stream<List<Payment>> getPayments(String userId);

  Stream<List<Payment>> getPaymentsBetween(String userId, DateTime from, DateTime to);
}