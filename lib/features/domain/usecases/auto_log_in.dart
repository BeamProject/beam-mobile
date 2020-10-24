
import 'package:beam/features/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AutoLogIn {
  final UserRepository _userRepository;

  AutoLogIn(this._userRepository);

  void call() {
    _userRepository.restoreSession();
  }
}