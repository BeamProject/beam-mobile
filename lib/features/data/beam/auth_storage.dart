import 'package:beam/features/data/beam/credentials.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthStorage {
  static const AUTH_TOKEN_KEY = 'auth_token';
  static const REFRESH_TOKEN_KEY = 'refresh_token';
  static const TOKEN_EXPIRATION_KEY = 'token_expiration';
  final FlutterSecureStorage _storage;

  AuthStorage(this._storage);

  Future<Credentials?> getCredentials() async {
    final all = await _storage.readAll();
    final authToken = all[AUTH_TOKEN_KEY];
    final refreshToken = all[REFRESH_TOKEN_KEY];
    if (authToken == null) {
      return null;
    }
    final expirationInt = int.tryParse(all[TOKEN_EXPIRATION_KEY] ?? "");
    final expiration = (expirationInt != null)
        ? DateTime.fromMillisecondsSinceEpoch(expirationInt)
        : null;
    return Credentials(
        authToken: authToken,
        refreshToken: refreshToken,
        expiration: expiration);
  }

  Future<void> updateCredentials(Credentials credentials) {
    var futures = <Future>[];
    futures
        .add(_storage.write(key: AUTH_TOKEN_KEY, value: credentials.authToken));
    futures.add(_storage.write(
        key: REFRESH_TOKEN_KEY, value: credentials.refreshToken));
    futures.add(_storage.write(
        key: TOKEN_EXPIRATION_KEY,
        value:
            credentials.expiration?.millisecondsSinceEpoch.toString() ?? ''));
    return Future.wait(futures);
  }
}
