import 'package:beam/features/domain/entities/login_result.dart';
import 'package:beam/features/domain/entities/user.dart';

abstract class UserRepository {
  Future<LoginResult> logIn(
      String username, String password);

  Stream<User> observeUser();

  Future<void> logOut();

  void restoreSession();
}