import 'package:beam/features/data/beam/auth_storage.dart';
import 'package:beam/features/data/beam/credentials.dart';

class AuthTokenManager {
  static const _AUTH_HEADER_PREFIX = "JWT";
  final AuthStorage _authStorage;
  Credentials _cachedCredentials;

  AuthTokenManager(this._authStorage);

  Future<String> getAuthToken() async {
    if (_cachedCredentials == null) {
      _cachedCredentials = await _authStorage.getCredentials();
    }
    if (_cachedCredentials.isExpired) {
      _cachedCredentials = await renewAuth(_cachedCredentials.refreshToken);
      _authStorage.updateCredentials(_cachedCredentials);
    }
    return _cachedCredentials.authToken;
  }

  Future<String> getAuthHeader() async {
    final token = await getAuthToken();
    if (token == null) {
      return null;
    }
    return '$_AUTH_HEADER_PREFIX ' + token;
  }

  Future<void> saveCredentials(Credentials credentials) {
    _cachedCredentials = credentials;
    return _authStorage.updateCredentials(credentials);
  }

  Future<Credentials> renewAuth(String refreshToken) {
    // Call BeamService to renew auth token.
    throw UnimplementedError();
  }
}
