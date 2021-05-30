import 'package:beam/common/di/config.dart';
import 'package:beam/features/domain/entities/payment_request.dart';
import 'package:beam/features/domain/entities/payment_result.dart';
import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/repositories/testing/fake_user_repository.dart';
import 'package:beam/features/domain/repositories/testing/repository_module.mocks.dart';
import 'package:beam/features/domain/usecases/make_delayed_payment.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' as injectable;
import 'package:mockito/mockito.dart';

void main() {
  late FakeUserRepository fakeUserRepository;
  late MockPaymentRepository mockPaymentRepository;

  setUp(() {
    configureDependencies(injectable.Environment.test);
    fakeUserRepository = getIt<FakeUserRepository>();
    mockPaymentRepository = getIt<MockPaymentRepository>();
  });

  tearDown(() {
    getIt.reset();
  });

  test('make delayed payment, current user is null, error', () {
    fakeUserRepository.usersStream = Stream.fromIterable([null]);
    final makeDelayedPayment =
        MakeDelayedPayment(mockPaymentRepository, fakeUserRepository);

    expect(makeDelayedPayment(10, "USD"),
        completion(PaymentResult.ERROR_INVALID_USER));
  });

  test('make delayed payment', () async {
    fakeUserRepository.usersStream = Stream.fromIterable(
        [User(id: "1", firstName: 'John', lastName: 'Doe')]);
    when(mockPaymentRepository.makeDelayedPayment(any)).thenAnswer((_) => Future.value(PaymentResult.SUCCESS));
    final makeDelayedPayment =
        MakeDelayedPayment(mockPaymentRepository, fakeUserRepository);

    await makeDelayedPayment(10, "USD");

    verify(mockPaymentRepository
        .makeDelayedPayment(PaymentRequest(userId: "1", amount: 10, currency: "USD")));
  });
}
