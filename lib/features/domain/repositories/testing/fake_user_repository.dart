import 'package:beam/features/domain/entities/login_result.dart';
import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

@singleton
class FakeUserRepository extends Fake implements UserRepository {
  Stream<User?> usersStream = Stream<User?>.empty();
  LoginResult _loginResult = LoginResult.SUCCESS;

  @override
  Stream<User?> observeUser() {
    return usersStream;
  }

  @override
  Future<LoginResult> logIn(
      String username, String password) {
    return Future.value(_loginResult);
  }

  void setExpectedLoginResult(LoginResult loginResult) {
    _loginResult = loginResult;
  }
}
