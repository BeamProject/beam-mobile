import 'package:beam/features/domain/entities/login_result.dart';
import 'package:beam/features/domain/repositories/user_repository.dart';
import 'package:beam/features/domain/usecases/log_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FakeUserRepository extends Fake implements UserRepository {
  LoginResult _loginResult = LoginResult.SUCCESS;

  @override
  Future<LoginResult> logIn(
      String username, String password) {
    return Future.value(_loginResult);
  }

  void setExpectedLoginResult(LoginResult loginResult) {
    _loginResult = loginResult;
  }
}

void main() {
  final userRepository = FakeUserRepository();

  test("Logs in successfully", () {
    final logIn = LogIn(userRepository);
    expect(logIn("John", "password"), completion(equals(LoginResult.SUCCESS)));
  });

  test("Credential error", () {
    userRepository.setExpectedLoginResult(LoginResult.ERROR);
    final logIn = LogIn(userRepository);
    expect(logIn("John", "password"),
        completion(equals(LoginResult.ERROR)));
  });

  test("Timeout", () {
    userRepository.setExpectedLoginResult(LoginResult.TIMEOUT);
    final logIn = LogIn(userRepository);
    expect(
        logIn("John", "password"), completion(equals((LoginResult.TIMEOUT))));
  });
}
