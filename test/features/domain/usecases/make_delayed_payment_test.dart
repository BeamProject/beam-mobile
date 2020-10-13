import 'package:beam/features/domain/entities/payment.dart';
import 'package:beam/features/domain/entities/payment_result.dart';
import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/repositories/payment_repository.dart';
import 'package:beam/features/domain/repositories/user_repository.dart';
import 'package:beam/features/domain/usecases/make_delayed_payment.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockPaymentRepository extends Mock implements PaymentRepository {}

void main() {
  MockUserRepository mockUserRepository;
  MockPaymentRepository mockPaymentRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockPaymentRepository = MockPaymentRepository();
  });

  test('make delayed payment, current user has no id, error', () {
    when(mockUserRepository.observeUser()).thenAnswer(
        (_) => Stream.fromIterable([User(firstName: 'John', lastName: 'Doe')]));
    final makeDelayedPayment =
        MakeDelayedPayment(mockPaymentRepository, mockUserRepository);

    expect(makeDelayedPayment(10, "USD"),
        completion(PaymentResult.ERROR_INVALID_USER));
  });

  test('make delayed payment, current user is null, error', () {
    when(mockUserRepository.observeUser())
        .thenAnswer((_) => Stream.fromIterable([null]));
    final makeDelayedPayment =
        MakeDelayedPayment(mockPaymentRepository, mockUserRepository);

    expect(makeDelayedPayment(10, "USD"),
        completion(PaymentResult.ERROR_INVALID_USER));
  });

  test('make delayed payment', () async {
    when(mockUserRepository.observeUser()).thenAnswer((_) =>
        Stream.fromIterable(
            [User(id: "1", firstName: 'John', lastName: 'Doe')]));
    final makeDelayedPayment =
        MakeDelayedPayment(mockPaymentRepository, mockUserRepository);

    await makeDelayedPayment(10, "USD");

    verify(mockPaymentRepository
        .makeDelayedPayment(Payment(userId: "1", amount: 10, currency: "USD")));
  });
}
