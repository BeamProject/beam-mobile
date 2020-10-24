import 'package:beam/features/domain/entities/payment.dart';
import 'package:beam/features/domain/entities/payment_result.dart';
import 'package:beam/features/domain/entities/user.dart';
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
    if (!_isValidUser(user)) {
      return PaymentResult.ERROR_INVALID_USER;
    }
    return _paymentRepository.makeDelayedPayment(
        Payment(userId: user.id, amount: amount, currency: currency));
  }

  bool _isValidUser(User user) {
    return user != null && user.id != null;
  }
}
