import 'package:beam/features/data/datasources/payments_local_data_source.dart';
import 'package:beam/features/data/datasources/payments_remote_data_source.dart';
import 'package:beam/features/data/datasources/steps/step_counter_local_data_source.dart';
import 'package:beam/features/data/datasources/user_local_data_source.dart';
import 'package:beam/features/data/datasources/user_remote_data_source.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

@singleton
class MockPaymentRemoteDataSource extends Mock
    implements PaymentsRemoteDataSource {}

@singleton
class MockPaymentsLocalDataSource extends Mock
    implements PaymentsLocalDataSource {}

@singleton
class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

@singleton
class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

@singleton
class MockStepCounterLocalDataSource extends Mock
    implements StepCounterLocalDataSource {}

@module
abstract class DataSourcesModule {
  @Injectable(env: [Environment.test])
  PaymentsRemoteDataSource paymentsRemoteDataSource(
          MockPaymentRemoteDataSource mockPaymentRemoteDataSource) =>
      mockPaymentRemoteDataSource;

  @Injectable(env: [Environment.test])
  PaymentsLocalDataSource paymentsLocalDataSource(
          MockPaymentsLocalDataSource mockPaymentsLocalDataSource) =>
      mockPaymentsLocalDataSource;

  @Injectable(env: [Environment.test])
  UserLocalDataSource userLocalDataSource(
          MockUserLocalDataSource mockUserLocalDataSource) =>
      mockUserLocalDataSource;

  @Injectable(env: [Environment.test])
  UserRemoteDataSource userRemoteDataSource(
          MockUserRemoteDataSource mockUserRemoteDataSource) =>
      mockUserRemoteDataSource;

  @Injectable(env: [Environment.test])
  StepCounterLocalDataSource stepCounterLocalDataSource(
          MockStepCounterLocalDataSource mockStepCounterLocalDataSource) =>
      mockStepCounterLocalDataSource;
}
