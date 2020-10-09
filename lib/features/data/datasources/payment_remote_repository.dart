import 'package:beam/features/data/model/payment.dart';
import 'package:beam/features/domain/entities/payment_result.dart';

abstract class PaymentRemoteRepository {
  Future<PaymentResult> makeDelayedPayment(Payment payment);
}