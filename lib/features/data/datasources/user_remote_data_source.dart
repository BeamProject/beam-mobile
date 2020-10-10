import 'package:beam/features/domain/entities/login_result.dart';
import 'package:beam/features/domain/entities/user.dart';

abstract class UserRemoteDataSource {
  Future<LoginResult> logIn(
      String username, String password);
  
  Future<User> getUser();
}
