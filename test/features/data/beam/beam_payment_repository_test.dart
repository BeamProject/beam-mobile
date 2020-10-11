import 'package:beam/features/data/beam/auth_storage.dart';
import 'package:beam/features/data/beam/auth_token_manager.dart';
import 'package:beam/features/data/beam/beam_payment_repository.dart';
import 'package:beam/features/data/beam/beam_service.dart';
import 'package:beam/features/data/beam/beam_service_auth_wrapper.dart';
import 'package:beam/features/data/beam/credentials.dart';
import 'package:beam/features/domain/entities/payment.dart';
import 'package:beam/features/domain/entities/payment_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import '../../../fakes/fake_storage.dart';

class MockBeamService extends Mock implements BeamService {}

void main() {
  final testPayment = Payment(userId: "1", amount: 20, currency: "USD");
  MockBeamService mockBeamService;
  BeamServiceAuthWrapper beamServiceAuthWrapper;
  AuthTokenManager authTokenManager;

  setUp(() {
    authTokenManager = AuthTokenManager(AuthStorage(FakeStorage()));
    mockBeamService = MockBeamService();
    beamServiceAuthWrapper =
        BeamServiceAuthWrapper(authTokenManager, mockBeamService);
  });

  group('make payment', () {
    setUp(() async {
      await authTokenManager.saveCredentials(Credentials(authToken: "token"));
    });

    test('success', () {
      when(mockBeamService.post(BeamPaymentRepository.MAKE_DELAYED_PAYMENT_API,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) => Future.value(Response('{"success": true}', 200)));
      final beamPaymentRepository =
          BeamPaymentRepository(beamServiceAuthWrapper);

      expect(beamPaymentRepository.makeDelayedPayment(testPayment),
          completion(PaymentResult.SUCCESS));
    });

    test('response with success false', () {
      when(mockBeamService.post(BeamPaymentRepository.MAKE_DELAYED_PAYMENT_API,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) => Future.value(Response('{"success": false}', 200)));
      final beamPaymentRepository =
          BeamPaymentRepository(beamServiceAuthWrapper);

      expect(beamPaymentRepository.makeDelayedPayment(testPayment),
          completion(PaymentResult.ERROR_UNKNOWN));
    });

    test('authentication error', () {
      when(mockBeamService.post(BeamPaymentRepository.MAKE_DELAYED_PAYMENT_API,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) => Future.value(Response("Error", 401)));
      final beamPaymentRepository =
          BeamPaymentRepository(beamServiceAuthWrapper);

      expect(beamPaymentRepository.makeDelayedPayment(testPayment),
          completion(PaymentResult.ERROR_INVALID_USER));
    });

    test('response null', () {
      when(mockBeamService.post(BeamPaymentRepository.MAKE_DELAYED_PAYMENT_API,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) => Future.value(null));
      final beamPaymentRepository =
          BeamPaymentRepository(beamServiceAuthWrapper);

      expect(beamPaymentRepository.makeDelayedPayment(testPayment),
          completion(PaymentResult.ERROR_UNKNOWN));
    });
  });
}
