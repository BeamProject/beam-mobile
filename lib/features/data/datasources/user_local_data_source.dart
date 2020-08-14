import 'package:beam/features/data/model/user.dart';

abstract class UserLocalDataSource {
  Future<User> getUser();

  Future<void> updateUser(User user);

  Future<void> removeCurrentUser();
}