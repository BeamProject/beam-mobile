import 'package:beam/features/data/beam/model/payment.dart';
import 'package:beam/features/data/beam/model/payment_request.dart';
import 'package:beam/features/domain/entities/payment_request.dart' as entities;
import 'package:beam/features/domain/entities/payment.dart' as entities;

class PaymentMapper {
  static PaymentRequest mapToBeamPaymentRequest(
      entities.PaymentRequest payment) {
    return new PaymentRequest(
        userId: payment.userId,
        amount: payment.amount,
        currency: payment.currency);
  }

  static entities.Payment mapToPayment(Payment payment) {
    return new entities.Payment(
        id: payment.id,
        userId: payment.userId,
        amount: payment.amount,
        currency: payment.currency);
  }
}
