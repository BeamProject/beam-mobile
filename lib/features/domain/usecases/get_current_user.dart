import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ObserveUser {
  final UserRepository _userRepository;

  ObserveUser(this._userRepository);

  Stream<User?> call() {
    return _userRepository
        .observeUser()
        .map((user) => _isValidUser(user) ? user : null);
  }

  bool _isValidUser(User? user) {
    return user != null &&
        user.firstName != null &&
        user.lastName != null;
  }
}
