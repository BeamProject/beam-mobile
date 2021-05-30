import 'package:beam/features/domain/repositories/payment_repository.dart';
import 'package:beam/features/domain/repositories/testing/fake_user_repository.dart';
import 'package:beam/features/domain/repositories/testing/repository_module.mocks.dart';
import 'package:beam/features/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/annotations.dart';

@module
@GenerateMocks([PaymentRepository])
abstract class RepositoryModule {
  @Injectable(env: [Environment.test])
  UserRepository userRepository(FakeUserRepository fakeUserRepository) =>
      fakeUserRepository;

  @Singleton(env: [Environment.test])
  MockPaymentRepository get mockPaymentRepository;

  @Injectable(env: [Environment.test])
  PaymentRepository paymentRepository(
          MockPaymentRepository mockPaymentRepository) =>
      mockPaymentRepository;
}
