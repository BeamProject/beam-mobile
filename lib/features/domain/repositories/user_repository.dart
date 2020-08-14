import 'package:beam/features/domain/entities/user.dart';

abstract class UserRepository {
  Stream<User> observeUser();

  Future<void> logInWithEmailAndPassword(String username, String password);

  Future<void> logOut();

  void restoreSession();
}