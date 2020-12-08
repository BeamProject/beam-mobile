import 'package:beam/features/data/payment_repository_impl.dart';
import 'package:beam/features/data/step_counter_repository_impl.dart';
import 'package:beam/features/data/user_repository_impl.dart';
import 'package:beam/features/domain/repositories/payment_repository.dart';
import 'package:beam/features/domain/repositories/steps_repository.dart';
import 'package:beam/features/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DataRepositoryModule {
  @Injectable(env: [Environment.prod])
  PaymentRepository paymentRepository(
          PaymentRepositoryImpl paymentRepositoryImpl) =>
      paymentRepositoryImpl;

  @Injectable(env: [Environment.prod])
  UserRepository userRepository(UserRepositoryImpl userRepositoryImpl) =>
      userRepositoryImpl;

  @Injectable(env: [Environment.prod])
  StepsRepository stepCounterRepository(
          StepCounterRepositoryImpl stepCounterRepositoryImpl) =>
      stepCounterRepositoryImpl;
}
