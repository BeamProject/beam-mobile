import 'package:injectable/injectable.dart';

import '../entities/payment.dart';
import '../entities/user.dart';
import '../repositories/payment_repository.dart';
import '../repositories/user_repository.dart';

@injectable
class GetPayments {
  final PaymentRepository _paymentRepository;
  final UserRepository _userRepository;

  GetPayments(this._paymentRepository, this._userRepository);

  Stream<List<Payment>> call() async* {
    User user = await _userRepository.observeUser().first;
    if (user == null || !user.isValid()) {
      throw Exception("Current user is invalid");
    }
    yield* _paymentRepository.getPayments(user.id);
  }
}