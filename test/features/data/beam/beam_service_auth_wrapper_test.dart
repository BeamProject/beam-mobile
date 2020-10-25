import 'package:beam/common/di/config.dart';
import 'package:beam/features/data/beam/auth_token_manager.dart';
import 'package:beam/features/data/beam/beam_service_auth_wrapper.dart';
import 'package:beam/features/data/beam/credentials.dart';
import 'package:beam/features/data/beam/testing/mock_beam_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' as injectable;
import 'package:mockito/mockito.dart';

void main() {
  AuthTokenManager authTokenManager;
  MockBeamService mockBeamService;

  setUp(() {
    configureDependencies(injectable.Environment.test);
    authTokenManager = getIt<AuthTokenManager>();
    mockBeamService = getIt<MockBeamService>();
  });

  test('get makes an authenticated call to beamservice', () async {
    await authTokenManager.saveCredentials(
        Credentials(authToken: "token", refreshToken: "", expiration: null));
    final beamServiceAuthWrapper = getIt<BeamServiceAuthWrapper>();

    await beamServiceAuthWrapper.get("/users/me");

    final authHeader = await authTokenManager.getAuthHeader();
    verify(mockBeamService.get("/users/me", headers: {
      BeamServiceAuthWrapper.AUTHENTICATION_HEADER_KEY: authHeader
    }));
  });
}
