import 'package:beam/common/di/config.dart';
import 'package:beam/features/data/beam/auth_storage.dart';
import 'package:beam/features/data/beam/auth_token_manager.dart';
import 'package:beam/features/data/beam/credentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' as injectable;

void main() {
  AuthTokenManager authTokenManager;
  AuthStorage authStorage;

  setUp(() {
    configureDependencies(injectable.Environment.test);
    authTokenManager = getIt<AuthTokenManager>();
    authStorage = getIt<AuthStorage>();
  });

  tearDown(() {
    getIt.reset();
  });

  test('getAuthToken returns null at init', () {
    expect(authTokenManager.getAuthToken(), completion(null));
  });

  test('getAuthToken returns stored token', () async {
    await authStorage.updateCredentials(_createCredentials("token"));

    expect(authTokenManager.getAuthToken(), completion("token"));
  });

  test('getAuthToken caches the token', () async {
    await authStorage.updateCredentials(_createCredentials("token"));
    await authTokenManager.getAuthToken();
    await authStorage.updateCredentials(_createCredentials(""));

    expect(authTokenManager.getAuthToken(), completion("token"));
  });

  test('saveCredentials and getAuthToken', () async {
    await authTokenManager.saveCredentials(_createCredentials("token"));
    expect(authTokenManager.getAuthToken(), completion("token"));
  });

  test('saveCredentials caches the token', () async {
    await authTokenManager.saveCredentials(_createCredentials("token"));
    await authStorage.updateCredentials(_createCredentials(""));

    expect(authTokenManager.getAuthToken(), completion("token"));
  });

  test('getAuthHeader', () async {
    await authTokenManager.saveCredentials(_createCredentials("token"));

    expect(authTokenManager.getAuthHeader(), completion("JWT token"));
  });
}

Credentials _createCredentials(String token) {
  return Credentials(authToken: token, refreshToken: "", expiration: null);
}
