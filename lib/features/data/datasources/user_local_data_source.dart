import 'package:beam/features/domain/entities/user.dart';

abstract class UserLocalDataSource {
  Future<User?> getUser();

  Future<void> updateUser(User user);

  Future<void> removeCurrentUser();
}