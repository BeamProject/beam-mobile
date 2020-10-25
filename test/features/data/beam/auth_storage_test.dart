import 'package:beam/common/di/config.dart';
import 'package:beam/features/data/beam/auth_storage.dart';
import 'package:beam/features/data/beam/credentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' as injectable;

void main() {
  AuthStorage authStorage;

  setUp(() {
    configureDependencies(injectable.Environment.test);
    authStorage = getIt<AuthStorage>();
  });

  tearDown(() {
    getIt.reset();
  });

  test("get credentials returns empty at init", () {
    expect(
        authStorage.getCredentials(),
        completion(Credentials(
            authToken: null, refreshToken: null, expiration: null)));
  });

  test("update and get credentials", () async {
    final credentials = Credentials(
        authToken: "token",
        refreshToken: "refreshToken",
        expiration: DateTime(2020, 01, 01));
    await authStorage.updateCredentials(credentials);

    expect(authStorage.getCredentials(), completion(credentials));
  });
}
