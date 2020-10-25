import 'package:beam/common/di/config.dart';
import 'package:beam/features/data/beam/auth_token_manager.dart';
import 'package:beam/features/data/beam/beam_user_repository.dart';
import 'package:beam/features/data/beam/credentials.dart';
import 'package:beam/features/data/beam/testing/mock_beam_service.dart';
import 'package:beam/features/domain/entities/login_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart' as injectable;
import 'package:mockito/mockito.dart';

void main() {
  MockBeamService mockBeamService;
  AuthTokenManager authTokenManager;

  group('logIn success', () {
    final authTokenValue = "tokenvalue";

    setUp(() {
      configureDependencies(injectable.Environment.test);
      authTokenManager = getIt<AuthTokenManager>();
      mockBeamService = getIt<MockBeamService>();
      when(mockBeamService.post(BeamUserRepository.LOGIN_API,
              body: anyNamed('body')))
          .thenAnswer((_) => Future.value(Response(
              '{"${Credentials.AUTH_TOKEN_KEY}": "$authTokenValue"}', 200)));
    });
    
    tearDown(() {
      getIt.reset();
    });

    test('returns success result', () {
      final beamUserRepository = getIt<BeamUserRepository>();

      expect(beamUserRepository.logIn("username", "password"),
          completion(LoginResult.SUCCESS));
    });

    test('saves credentials', () async {
      final beamUserRepository = getIt<BeamUserRepository>();

      await beamUserRepository.logIn("username", "password");

      expect(authTokenManager.getAuthToken(), completion(authTokenValue));
    });
  });

  group('logIn failure', () {
    setUp(() {
      configureDependencies(injectable.Environment.test);
      authTokenManager = getIt<AuthTokenManager>();
      mockBeamService = getIt<MockBeamService>();
      when(mockBeamService.post(BeamUserRepository.LOGIN_API,
              body: anyNamed('body')))
          .thenAnswer((_) => Future.value(Response("Error", 401)));
    });

    test('returns error result', () {
      final beamUserRepository = getIt<BeamUserRepository>();

      expect(beamUserRepository.logIn("username", "password"),
          completion(LoginResult.ERROR));
    });

    tearDown(() {
      getIt.reset();
    });
  });
}
