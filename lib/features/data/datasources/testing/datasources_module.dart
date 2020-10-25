import 'package:beam/features/data/datasources/payment_remote_repository.dart';
import 'package:beam/features/data/datasources/user_local_data_source.dart';
import 'package:beam/features/data/datasources/user_remote_data_source.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

@singleton
class MockPaymentRemoteRepository extends Mock
    implements PaymentRemoteRepository {}

@singleton
class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

@singleton
class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

@module
abstract class DataSourcesModule {
  @Injectable(env: [Environment.test])
  PaymentRemoteRepository paymentRemoteRepository(
          MockPaymentRemoteRepository mockPaymentRemoteRepository) =>
      mockPaymentRemoteRepository;

  @Injectable(env: [Environment.test])
  UserLocalDataSource userLocalDataSource(
      MockUserLocalDataSource mockUserLocalDataSource) =>
      mockUserLocalDataSource;

  @Injectable(env: [Environment.test])
  UserRemoteDataSource userRemoteDataSource(
      MockUserRemoteDataSource mockUserRemoteDataSource) =>
      mockUserRemoteDataSource;
}
