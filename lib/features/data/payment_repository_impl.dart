import 'package:beam/features/data/datasources/payment_remote_repository.dart';
import 'package:beam/features/domain/entities/payment.dart';
import 'package:beam/features/domain/entities/payment_result.dart';
import 'package:beam/features/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl extends PaymentRepository {
  final PaymentRemoteRepository _paymentRemoteRepository;

  PaymentRepositoryImpl(this._paymentRemoteRepository);

  @override
  Future<PaymentResult> makeDelayedPayment(Payment payment) {
    return _paymentRemoteRepository.makeDelayedPayment(payment);
  }
}
