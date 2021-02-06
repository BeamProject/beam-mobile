import 'package:beam/features/domain/entities/payment.dart';
import 'package:beam/features/domain/entities/payment_request.dart';
import 'package:beam/features/domain/entities/payment_result.dart';

abstract class PaymentsRemoteDataSource {
  Future<PaymentResult> makeDelayedPayment(PaymentRequest paymentRequest);

  Stream<List<Payment>> getPayments(String userId);
}