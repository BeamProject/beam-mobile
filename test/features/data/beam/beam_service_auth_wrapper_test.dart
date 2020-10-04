import 'package:beam/features/data/beam/auth_storage.dart';
import 'package:beam/features/data/beam/auth_token_manager.dart';
import 'package:beam/features/data/beam/beam_service.dart';
import 'package:beam/features/data/beam/beam_service_auth_wrapper.dart';
import 'package:beam/features/data/beam/credentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fakes/fake_storage.dart';

class MockBeamService extends Mock implements BeamService {}

void main() {
  AuthTokenManager authTokenManager;

  setUp(() {
    authTokenManager = AuthTokenManager(AuthStorage(FakeStorage()));
  });

  test('get makes an authenticated call to beamservice', () async {
    final mockBeamService = MockBeamService();
    final beamServiceAuthWrapper =
        BeamServiceAuthWrapper(authTokenManager, mockBeamService);
    await authTokenManager.saveCredentials(
        Credentials(authToken: "token", refreshToken: "", expiration: null));
    final authHeader = await authTokenManager.getAuthHeader();

    await beamServiceAuthWrapper.get("/users/me");

    verify(mockBeamService.get("/users/me", headers: {
      BeamServiceAuthWrapper.AUTHENTICATION_HEADER_KEY: authHeader
    }));
  });
}
