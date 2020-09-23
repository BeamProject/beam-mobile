import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/repositories/user_repository.dart';

class GetCurrentUser {
  final UserRepository _userRepository;

  GetCurrentUser(this._userRepository);

  Stream<User> call() {
    return _userRepository.observeUser();
  }
}
