import 'package:beam/features/data/model/payment.dart';
import 'package:beam/features/domain/entities/payment.dart' as entities;

class PaymentMapper {
  static Payment mapToPayment(entities.Payment payment) {
    return new Payment(
        userId: payment.userId,
        amount: payment.amount,
        currency: payment.currency);
  }
}
