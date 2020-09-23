import 'package:beam/features/domain/entities/login_result.dart';
import 'package:beam/features/domain/entities/user.dart';

abstract class UserRepository {
  Stream<User> observeUser();

  Future<LoginResult> logInWithEmailAndPassword(String username, String password);

  Future<void> logOut();

  void restoreSession();
}