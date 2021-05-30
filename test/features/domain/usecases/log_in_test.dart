import 'package:beam/common/di/config.dart';
import 'package:beam/features/domain/entities/login_result.dart';
import 'package:beam/features/domain/repositories/testing/fake_user_repository.dart';
import 'package:beam/features/domain/usecases/log_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' as injectable;

void main() {
  late FakeUserRepository fakeUserRepository;

  setUp(() {
    configureDependencies(injectable.Environment.test);
    fakeUserRepository = getIt<FakeUserRepository>();
  });

  tearDown(() {
    getIt.reset();
  });

  test("Logs in successfully", () {
    final logIn = getIt<LogIn>();
    expect(logIn("John", "password"), completion(equals(LoginResult.SUCCESS)));
  });

  test("Credential error", () {
    fakeUserRepository.setExpectedLoginResult(LoginResult.ERROR);
    final logIn = getIt<LogIn>();
    expect(logIn("John", "password"),
        completion(equals(LoginResult.ERROR)));
  });

  test("Timeout", () {
    fakeUserRepository.setExpectedLoginResult(LoginResult.TIMEOUT);
    final logIn = getIt<LogIn>();
    expect(
        logIn("John", "password"), completion(equals((LoginResult.TIMEOUT))));
  });
}
