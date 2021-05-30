import 'package:beam/features/data/datasources/payments_local_data_source.dart';
import 'package:beam/features/data/datasources/payments_remote_data_source.dart';
import 'package:beam/features/data/datasources/steps/step_counter_local_data_source.dart';
import 'package:beam/features/data/datasources/user_local_data_source.dart';
import 'package:beam/features/data/datasources/user_remote_data_source.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/annotations.dart';

import 'datasources_module.mocks.dart';

@module
@GenerateMocks([
  StepCounterLocalDataSource,
  UserRemoteDataSource,
  UserLocalDataSource,
  PaymentsLocalDataSource,
  PaymentsRemoteDataSource
])
abstract class DataSourcesModule {
  @Singleton(env: [Environment.test])
  MockPaymentsRemoteDataSource get mockPaymentsRemoteDataSource;

  @Injectable(env: [Environment.test])
  PaymentsRemoteDataSource paymentsRemoteDataSource(
          MockPaymentsRemoteDataSource mockPaymentRemoteDataSource) =>
      mockPaymentRemoteDataSource;

  @Singleton(env: [Environment.test])
  MockPaymentsLocalDataSource get mockPaymentsLocalDataSource;

  @Injectable(env: [Environment.test])
  PaymentsLocalDataSource paymentsLocalDataSource(
          MockPaymentsLocalDataSource mockPaymentsLocalDataSource) =>
      mockPaymentsLocalDataSource;

  @Singleton(env: [Environment.test])
  MockUserLocalDataSource get mockUserLocalDataSource;

  @Injectable(env: [Environment.test])
  UserLocalDataSource userLocalDataSource(
          MockUserLocalDataSource mockUserLocalDataSource) =>
      mockUserLocalDataSource;

  @Singleton(env: [Environment.test])
  MockUserRemoteDataSource get mockUserRemoteDataSource;

  @Injectable(env: [Environment.test])
  UserRemoteDataSource userRemoteDataSource(
          MockUserRemoteDataSource mockUserRemoteDataSource) =>
      mockUserRemoteDataSource;

  @Singleton(env: [Environment.test])
  MockStepCounterLocalDataSource get mockStepCounterLocalDataSource;

  // TODO: Change this to a fake instead of a mock.
  @Injectable(env: [Environment.test])
  StepCounterLocalDataSource stepCounterLocalDataSource(
          MockStepCounterLocalDataSource mockStepCounterLocalDataSource) =>
      mockStepCounterLocalDataSource;
}
