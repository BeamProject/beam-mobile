import 'package:beam/common/di/config.dart';
import 'package:beam/features/data/datasources/testing/datasources_module.dart';
import 'package:beam/features/data/payment_repository_impl.dart';
import 'package:beam/features/domain/entities/payment_request.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' as injectable;
import 'package:mockito/mockito.dart';

void main() {
  MockPaymentRemoteRepository mockPaymentRemoteRepository;

  setUp(() {
    configureDependencies(injectable.Environment.test);
    mockPaymentRemoteRepository = getIt<MockPaymentRemoteRepository>();
  });

  test('make delayed payment', () {
    final paymentRepositoryImpl = getIt<PaymentRepositoryImpl>();
    final payment = PaymentRequest(userId: "1", amount: 10, currency: "USD");

    paymentRepositoryImpl.makeDelayedPayment(payment);

    verify(mockPaymentRemoteRepository.makeDelayedPayment(payment));
  });
}
