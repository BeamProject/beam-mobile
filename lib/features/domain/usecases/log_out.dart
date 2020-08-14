import 'package:beam/features/domain/repositories/user_repository.dart';

class LogOut {
  final UserRepository _userRepository;

  LogOut(this._userRepository);

  Future<void> call() {
    return _userRepository.logOut();
  }
}
