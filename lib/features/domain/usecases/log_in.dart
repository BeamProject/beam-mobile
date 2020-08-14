
import 'package:beam/features/domain/repositories/user_repository.dart';

class LogIn {
  final UserRepository _userRepository;

  LogIn(this._userRepository);

  Future<void> call(String username, String password) {
    return _userRepository.logInWithEmailAndPassword(username, password);
  }
}