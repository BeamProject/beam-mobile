import 'package:beam/features/domain/repositories/payment_repository.dart';
import 'package:beam/features/domain/repositories/testing/fake_user_repository.dart';
import 'package:beam/features/domain/repositories/testing/mock_payment_repository.dart';
import 'package:beam/features/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RepositoryModule {
  @Injectable(env: [Environment.test])
  UserRepository userRepository(FakeUserRepository fakeUserRepository) =>
      fakeUserRepository;

  @Injectable(env: [Environment.test])
  PaymentRepository paymentRepository(
          MockPaymentRepository mockPaymentRepository) =>
      mockPaymentRepository;
}
