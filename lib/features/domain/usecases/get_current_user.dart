import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/repositories/user_repository.dart';

class ObserveUser {
  final UserRepository _userRepository;

  ObserveUser(this._userRepository);

  Stream<User> call() {
    return _userRepository.observeUser();
  }
}
