import 'package:beam/features/data/beam/auth_storage.dart';
import 'package:beam/features/data/beam/auth_token_manager.dart';
import 'package:beam/features/data/beam/credentials.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fakes/fake_storage.dart';

void main() {
  AuthTokenManager authTokenManager;
  FakeStorage fakeStorage;

  setUp(() {
    fakeStorage = FakeStorage();
    authTokenManager = AuthTokenManager(AuthStorage(fakeStorage));
  });

  test('get returns null at init', () {
    expect(authTokenManager.getAuthToken(), completion(null));
  });

  test('save and get token', () async {
    await authTokenManager.saveCredentials(
        Credentials(authToken: "token", refreshToken: "", expiration: null));
    expect(authTokenManager.getAuthToken(), completion("token"));
  });

  test('get token without cache', () async {
    await authTokenManager.saveCredentials(
        Credentials(authToken: "token", refreshToken: "", expiration: null));
    authTokenManager = AuthTokenManager(AuthStorage(fakeStorage));

    expect(authTokenManager.getAuthToken(), completion("token"));
  });

  test('get token caches the token', () async {
    await authTokenManager.saveCredentials(
        Credentials(authToken: "token", refreshToken: "", expiration: null));
    authTokenManager = AuthTokenManager(AuthStorage(fakeStorage));
    await authTokenManager.getAuthToken();
    fakeStorage.deleteAll();

    expect(authTokenManager.getAuthToken(), completion("token"));
  });

  test('save token caches the token', () async {
    await authTokenManager.saveCredentials(
        Credentials(authToken: "token", refreshToken: "", expiration: null));
    fakeStorage.deleteAll();

    expect(authTokenManager.getAuthToken(), completion("token"));
  });

  test('get auth header', () async {
    await authTokenManager.saveCredentials(
        Credentials(authToken: "token", refreshToken: "", expiration: null));

    expect(authTokenManager.getAuthHeader(), completion("JWT token"));
  });
}
