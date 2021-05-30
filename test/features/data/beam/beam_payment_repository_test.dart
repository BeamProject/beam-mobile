import 'package:beam/common/di/config.dart';
import 'package:beam/features/data/beam/auth_token_manager.dart';
import 'package:beam/features/data/beam/beam_payment_repository.dart';
import 'package:beam/features/data/beam/credentials.dart';
import 'package:beam/features/data/beam/testing/test_beam_module.mocks.dart';
import 'package:beam/features/domain/entities/payment_request.dart';
import 'package:beam/features/domain/entities/payment_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart' as injectable;
import 'package:mockito/mockito.dart';

void main() {
  final testPayment = PaymentRequest(userId: "1", amount: 20, currency: "USD");
  late MockBeamService mockBeamService;
  late AuthTokenManager authTokenManager;

  setUp(() {
    configureDependencies(injectable.Environment.test);
    authTokenManager = getIt<AuthTokenManager>();
    mockBeamService = getIt<MockBeamService>();
  });

  tearDown(() {
    getIt.reset();
  });

  group('make payment', () {
    setUp(() async {
      await authTokenManager.saveCredentials(Credentials(authToken: "token"));
    });

    test('success', () {
      when(mockBeamService.post(BeamPaymentRepository.MAKE_DELAYED_PAYMENT_API,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) => Future.value(Response('{"success": true}', 200)));
      final beamPaymentRepository = getIt<BeamPaymentRepository>();

      expect(beamPaymentRepository.makeDelayedPayment(testPayment),
          completion(PaymentResult.SUCCESS));
    });

    test('response with success false', () {
      when(mockBeamService.post(BeamPaymentRepository.MAKE_DELAYED_PAYMENT_API,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) => Future.value(Response('{"success": false}', 200)));
      final beamPaymentRepository = getIt<BeamPaymentRepository>();

      expect(beamPaymentRepository.makeDelayedPayment(testPayment),
          completion(PaymentResult.ERROR_UNKNOWN));
    });

    test('authentication error', () {
      when(mockBeamService.post(BeamPaymentRepository.MAKE_DELAYED_PAYMENT_API,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) => Future.value(Response("Error", 401)));
      final beamPaymentRepository = getIt<BeamPaymentRepository>();

      expect(beamPaymentRepository.makeDelayedPayment(testPayment),
          completion(PaymentResult.ERROR_INVALID_USER));
    });
  });
}
