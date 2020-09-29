import 'package:beam/features/data/model/user.dart';
import 'package:beam/features/domain/entities/login_result.dart';

abstract class UserRemoteDataSource {
  Future<LoginResult> logIn(
      String username, String password);
  
  Future<User> getUser();
}
