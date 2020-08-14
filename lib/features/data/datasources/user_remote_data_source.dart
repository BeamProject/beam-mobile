import 'package:beam/features/data/model/user.dart';

abstract class UserRemoteDataSource {
  Future<User> logInWithEmailAndPassword(String username, String password);
}