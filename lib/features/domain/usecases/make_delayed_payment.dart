import 'package:beam/features/domain/entities/payment_request.dart';
import 'package:beam/features/domain/entities/payment_result.dart';
import 'package:beam/features/domain/repositories/payment_repository.dart';
import 'package:beam/features/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class MakeDelayedPayment {
  final PaymentRepository _paymentRepository;
  final UserRepository _userRepository;

  MakeDelayedPayment(this._paymentRepository, this._userRepository);

  Future<PaymentResult> call(int amount, String currency) async {
    final user = await _userRepository.observeUser().first;
    if (user == null) {
      return PaymentResult.ERROR_INVALID_USER;
    }
    return _paymentRepository.makeDelayedPayment(
        PaymentRequest(userId: user.id, amount: amount, currency: currency));
  }
}
