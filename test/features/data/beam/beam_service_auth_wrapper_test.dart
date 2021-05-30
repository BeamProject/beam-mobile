import 'package:beam/common/di/config.dart';
import 'package:beam/features/data/beam/auth_token_manager.dart';
import 'package:beam/features/data/beam/beam_service_auth_wrapper.dart';
import 'package:beam/features/data/beam/credentials.dart';
import 'package:beam/features/data/beam/testing/test_beam_module.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart' as injectable;
import 'package:mockito/mockito.dart';

void main() {
  late AuthTokenManager authTokenManager;
  late MockBeamService mockBeamService;

  setUp(() {
    configureDependencies(injectable.Environment.test);
    authTokenManager = getIt<AuthTokenManager>();
    mockBeamService = getIt<MockBeamService>();
  });

  test('get makes an authenticated call to beamservice', () async {
    await authTokenManager.saveCredentials(
        Credentials(authToken: "token", refreshToken: "", expiration: null));
    final authHeader = (await authTokenManager.getAuthHeader())!;
    when(mockBeamService.get("/users/me", headers: {
      BeamServiceAuthWrapper.AUTHENTICATION_HEADER_KEY: authHeader
    })).thenAnswer((_) => Future.value(Response('{"success": true}', 200)));
    final beamServiceAuthWrapper = getIt<BeamServiceAuthWrapper>();

    await beamServiceAuthWrapper.get("/users/me");

    verify(mockBeamService.get("/users/me", headers: {
      BeamServiceAuthWrapper.AUTHENTICATION_HEADER_KEY: authHeader
    }));
  });
}
