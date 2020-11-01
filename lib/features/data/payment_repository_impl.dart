import 'package:beam/features/data/datasources/payment_remote_repository.dart';
import 'package:beam/features/domain/entities/payment.dart';
import 'package:beam/features/domain/entities/payment_request.dart';
import 'package:beam/features/domain/entities/payment_result.dart';
import 'package:beam/features/domain/repositories/payment_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class PaymentRepositoryImpl extends PaymentRepository {
  final PaymentRemoteRepository _paymentRemoteRepository;

  PaymentRepositoryImpl(this._paymentRemoteRepository);

  @override
  Future<PaymentResult> makeDelayedPayment(PaymentRequest paymentRequest) {
    return _paymentRemoteRepository.makeDelayedPayment(paymentRequest);
  }

  @override
  Stream<List<Payment>> getPayments(String userId) {
    // TODO: Introduce a payment local datasource and show cached results when possible.
    return _paymentRemoteRepository.getPayments(userId);
  }
}
