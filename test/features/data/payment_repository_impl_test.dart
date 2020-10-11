import 'package:beam/features/data/datasources/payment_remote_repository.dart';
import 'package:beam/features/data/payment_repository_impl.dart';
import 'package:beam/features/domain/entities/payment.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockPaymentRemoteRepository extends Mock
    implements PaymentRemoteRepository {}

void main() {
  MockPaymentRemoteRepository mockPaymentRemoteRepository;

  setUp(() {
    mockPaymentRemoteRepository = MockPaymentRemoteRepository();
  });

  test('make delayed payment', () {
    final paymentRepositoryImpl =
        PaymentRepositoryImpl(mockPaymentRemoteRepository);
    final payment = Payment(userId: "1", amount: 10, currency: "USD");

    paymentRepositoryImpl.makeDelayedPayment(payment);

    verify(mockPaymentRemoteRepository.makeDelayedPayment(payment));
  });
}
