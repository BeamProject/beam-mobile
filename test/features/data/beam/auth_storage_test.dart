import 'package:beam/features/data/beam/auth_storage.dart';
import 'package:beam/features/data/beam/credentials.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fakes/fake_storage.dart';

void main() {
  AuthStorage authStorage;
  FakeStorage fakeStorage;

  setUp(() {
    fakeStorage = FakeStorage();
    authStorage = AuthStorage(fakeStorage);
  });

  test("get credentials returns empty at init", () {
    expect(
        authStorage.getCredentials(),
        completion(Credentials(
            authToken: null, refreshToken: null, expiration: null)));
  });

  test("update and get credentials", () async {
    final credentials = Credentials(authToken: "token",
        refreshToken: "refreshToken",
        expiration: DateTime(2020, 01, 01));
    await authStorage.updateCredentials(credentials);
    
    expect(authStorage.getCredentials(), completion(credentials));
  });
}
