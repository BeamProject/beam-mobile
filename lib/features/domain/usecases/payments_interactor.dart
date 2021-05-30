import 'package:injectable/injectable.dart';

import '../entities/payment.dart';
import '../entities/user.dart';
import '../repositories/payment_repository.dart';
import '../repositories/user_repository.dart';

@injectable
class PaymentsInteractor {
  final PaymentRepository _paymentRepository;
  final UserRepository _userRepository;

  PaymentsInteractor(this._paymentRepository, this._userRepository);

  Stream<List<Payment>> getPayments() async* {
    final user = await _getValidUserOrThrow();
    yield* _paymentRepository.getPayments(user.id);
  }

  Stream<List<Payment>> getPaymentsBetween(DateTime from, DateTime to) async* {
    final user = await _getValidUserOrThrow();
    yield* _paymentRepository.getPaymentsBetween(user.id, from, to);
  }

  Future<User> _getValidUserOrThrow() async {
    User? user = await _userRepository.observeUser().first;
    if (user == null) {
      throw Exception("Current user is invalid");
    }
    return user;
  }
}