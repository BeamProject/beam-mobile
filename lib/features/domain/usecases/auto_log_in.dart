
import 'package:beam/features/domain/repositories/user_repository.dart';

class AutoLogIn {
  final UserRepository _userRepository;

  AutoLogIn(this._userRepository);

  void call() {
    _userRepository.restoreSession();
  }
}