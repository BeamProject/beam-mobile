import 'package:beam/features/data/beam/auth_storage.dart';
import 'package:beam/features/data/beam/auth_token_manager.dart';
import 'package:beam/features/data/beam/beam_service.dart';
import 'package:beam/features/data/beam/beam_service_auth_wrapper.dart';
import 'package:beam/features/data/beam/beam_user_repository.dart';
import 'package:beam/features/data/beam/credentials.dart';
import 'package:beam/features/domain/entities/login_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import '../../../fakes/fake_storage.dart';

class MockBeamService extends Mock implements BeamService {}

void main() {
  MockBeamService mockBeamService;
  BeamServiceAuthWrapper beamServiceAuthWrapper;
  AuthTokenManager authTokenManager;

  setUp(() {
    authTokenManager = AuthTokenManager(AuthStorage(FakeStorage()));
  });

  group('logIn success', () {
    final authTokenValue = "tokenvalue";

    setUp(() {
      mockBeamService = MockBeamService();
      when(mockBeamService.post(BeamUserRepository.LOGIN_API,
              body: anyNamed('body')))
          .thenAnswer((_) => Future.value(Response(
              '{"${Credentials.AUTH_TOKEN_KEY}": "$authTokenValue"}', 200)));
      beamServiceAuthWrapper =
          BeamServiceAuthWrapper(authTokenManager, mockBeamService);
    });

    test('returns success result', () {
      final beamUserRepository = BeamUserRepository(
          beamServiceAuthWrapper, mockBeamService, authTokenManager);

      expect(beamUserRepository.logIn("username", "password"),
          completion(LoginResult.SUCCESS));
    });

    test('saves credentials', () async {
      final beamUserRepository = BeamUserRepository(
          beamServiceAuthWrapper, mockBeamService, authTokenManager);

      await beamUserRepository.logIn("username", "password");

      expect(authTokenManager.getAuthToken(), completion(authTokenValue));
    });
  });

  group('logIn failure', () {
    setUp(() {
      mockBeamService = MockBeamService();
      when(mockBeamService.post(BeamUserRepository.LOGIN_API,
              body: anyNamed('body')))
          .thenAnswer((_) => Future.value(Response("Error", 401)));
      beamServiceAuthWrapper =
          BeamServiceAuthWrapper(authTokenManager, mockBeamService);
    });

    test('returns error result', () {
      final beamUserRepository = BeamUserRepository(
          beamServiceAuthWrapper, mockBeamService, authTokenManager);

      expect(beamUserRepository.logIn("username", "password"),
          completion(LoginResult.ERROR));
    });
  });
}
