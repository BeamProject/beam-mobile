
import 'package:beam/features/domain/entities/login_result.dart';
import 'package:beam/features/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogIn {
  final UserRepository _userRepository;

  LogIn(this._userRepository);

  Future<LoginResult> call(String username, String password) {
    return _userRepository.logIn(username, password);
  }
}