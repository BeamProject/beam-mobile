// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../features/presentation/auth/auth_bloc.dart';
import '../../features/data/beam/auth_storage.dart';
import '../../features/data/beam/auth_token_manager.dart';
import '../../features/domain/usecases/auto_log_in.dart';
import '../../features/data/beam/inject/beam_module.dart';
import '../../features/data/beam/beam_payment_repository.dart';
import '../../features/data/beam/beam_service.dart';
import '../../features/data/beam/beam_service_auth_wrapper.dart';
import '../../features/data/beam/beam_user_repository.dart';
import '../../features/presentation/dashboard/model/dashboard_model.dart';
import '../../features/data/inject/repository_module.dart';
import '../../features/data/local/testing/fake_storage.dart';
import '../../features/data/local/testing/test_storage_module.dart';
import '../../features/domain/repositories/testing/fake_user_repository.dart';
import '../../features/domain/usecases/get_payments.dart';
import '../../features/domain/usecases/log_in.dart';
import '../../features/domain/usecases/log_out.dart';
import '../../features/presentation/login/bloc/login_bloc.dart';
import '../../features/domain/usecases/make_delayed_payment.dart';
import '../../features/data/beam/testing/mock_beam_service.dart';
import '../../features/data/datasources/testing/datasources_module.dart';
import '../../features/domain/repositories/testing/mock_payment_repository.dart';
import '../../features/domain/usecases/observe_step_count.dart';
import '../../features/domain/usecases/get_current_user.dart';
import '../../features/data/datasources/payment_remote_repository.dart';
import '../../features/domain/repositories/payment_repository.dart';
import '../../features/data/payment_repository_impl.dart';
import '../../features/presentation/payments/model/payments_model.dart';
import '../../features/data/pedometer/pedometer_module.dart';
import '../../features/data/pedometer/pedometer_service.dart';
import '../../features/domain/repositories/testing/repository_module.dart';
import '../../features/data/datasources/steps/step_counter_local_data_source.dart';
import '../../features/domain/repositories/step_counter_repository.dart';
import '../../features/data/step_counter_repository_impl.dart';
import '../../features/domain/repositories/step_counter_service.dart';
import '../../features/domain/usecases/step_counting_service_interactor.dart';
import '../../features/data/local/step_counter_storage.dart';
import '../../features/domain/entities/steps/step_tracker.dart';
import '../../features/domain/usecases/step_tracker_interactor.dart';
import '../../features/data/local/storage_module.dart';
import '../../features/data/beam/testing/test_beam_module.dart';
import '../../features/data/datasources/user_local_data_source.dart';
import '../../features/data/datasources/user_remote_data_source.dart';
import '../../features/domain/repositories/user_repository.dart';
import '../../features/data/user_repository_impl.dart';
import '../../features/data/local/user_storage.dart';

/// Environment names
const _prod = 'prod';
const _test = 'test';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  final fakeStorageModule = _$FakeStorageModule();
  final storageModule = _$StorageModule();
  final dataSourcesModule = _$DataSourcesModule();
  final repositoryModule = _$RepositoryModule();
  final pedometerModule = _$PedometerModule();
  final testBeamModule = _$TestBeamModule();
  final dataRepositoryModule = _$DataRepositoryModule();
  final beamModule = _$BeamModule();
  gh.factory<BeamService>(() => BeamService(), registerFor: {_prod});
  gh.lazySingleton<FlutterSecureStorage>(() => storageModule.storage,
      registerFor: {_prod});
  gh.factory<PaymentRemoteRepository>(
      () => dataSourcesModule
          .paymentRemoteRepository(get<MockPaymentRemoteRepository>()),
      registerFor: {_test});
  gh.factory<PaymentRepository>(
      () => repositoryModule.paymentRepository(get<MockPaymentRepository>()),
      registerFor: {_test});
  gh.factory<PaymentRepositoryImpl>(
      () => PaymentRepositoryImpl(get<PaymentRemoteRepository>()));
  gh.lazySingleton<PedometerService>(() => PedometerService());
  gh.factory<StepCounterService>(
      () => pedometerModule.stepCounterService(get<PedometerService>()),
      registerFor: {_prod});
  gh.factory<StepCounterServiceInteractor>(
      () => StepCounterServiceInteractor(get<StepCounterService>()));
  gh.factory<StepCounterStorage>(() => StepCounterStorage());
  gh.factory<UserLocalDataSource>(
      () => UserStorage(get<FlutterSecureStorage>()),
      registerFor: {_prod});
  gh.factory<UserLocalDataSource>(
      () =>
          dataSourcesModule.userLocalDataSource(get<MockUserLocalDataSource>()),
      registerFor: {_test});
  gh.factory<UserRemoteDataSource>(
      () => dataSourcesModule
          .userRemoteDataSource(get<MockUserRemoteDataSource>()),
      registerFor: {_test});
  gh.factory<UserRepository>(
      () => repositoryModule.userRepository(get<FakeUserRepository>()),
      registerFor: {_test});
  gh.lazySingleton<UserRepositoryImpl>(() => UserRepositoryImpl(
      get<UserLocalDataSource>(), get<UserRemoteDataSource>()));
  gh.factory<AuthStorage>(() => AuthStorage(get<FlutterSecureStorage>()));
  gh.lazySingleton<AuthTokenManager>(
      () => AuthTokenManager(get<AuthStorage>()));
  gh.factory<AutoLogIn>(() => AutoLogIn(get<UserRepository>()));
  gh.factory<BeamService>(
      () => testBeamModule.beamService(get<MockBeamService>()),
      registerFor: {_test});
  gh.factory<BeamServiceAuthWrapper>(() =>
      BeamServiceAuthWrapper(get<AuthTokenManager>(), get<BeamService>()));
  gh.factory<BeamUserRepository>(() => BeamUserRepository(
        get<BeamServiceAuthWrapper>(),
        get<BeamService>(),
        get<AuthTokenManager>(),
      ));
  gh.factory<GetPayments>(
      () => GetPayments(get<PaymentRepository>(), get<UserRepository>()));
  gh.factory<LogIn>(() => LogIn(get<UserRepository>()));
  gh.factory<LogOut>(() => LogOut(get<UserRepository>()));
  gh.factory<LoginCubit>(() => LoginCubit(get<LogIn>()));
  gh.factory<MakeDelayedPayment>(() =>
      MakeDelayedPayment(get<PaymentRepository>(), get<UserRepository>()));
  gh.factory<ObserveUser>(() => ObserveUser(get<UserRepository>()));
  gh.factory<PaymentRepository>(
      () =>
          dataRepositoryModule.paymentRepository(get<PaymentRepositoryImpl>()),
      registerFor: {_prod});
  gh.factory<PaymentsModel>(() => PaymentsModel(get<GetPayments>()));
  gh.factory<StepCounterLocalDataSource>(
      () => storageModule.stepCounterLocalDataSource(get<StepCounterStorage>()),
      registerFor: {_prod});
  gh.lazySingleton<StepCounterRepositoryImpl>(
      () => StepCounterRepositoryImpl(get<StepCounterLocalDataSource>()));
  gh.factory<UserRemoteDataSource>(
      () => beamModule.userRemoteDataSource(get<BeamUserRepository>()),
      registerFor: {_prod});
  gh.factory<UserRepository>(
      () => dataRepositoryModule.userRepository(get<UserRepositoryImpl>()),
      registerFor: {_prod});
  gh.factory<AuthCubit>(() => AuthCubit(
        get<ObserveUser>(),
        get<LogOut>(),
        get<AutoLogIn>(),
      ));
  gh.factory<BeamPaymentRepository>(
      () => BeamPaymentRepository(get<BeamServiceAuthWrapper>()));
  gh.factory<PaymentRemoteRepository>(
      () => beamModule.paymentRemoteRepository(get<BeamPaymentRepository>()),
      registerFor: {_prod});
  gh.factory<StepCounterRepository>(
      () => dataRepositoryModule
          .stepCounterRepository(get<StepCounterRepositoryImpl>()),
      registerFor: {_prod});
  gh.lazySingleton<StepTracker>(() =>
      StepTracker(get<StepCounterService>(), get<StepCounterRepository>()));
  gh.factory<StepTrackerInteractor>(
      () => StepTrackerInteractor(get<StepTracker>()));
  gh.factory<ObserveStepCount>(
      () => ObserveStepCount(get<StepCounterRepository>()));
  gh.factory<DashboardModel>(() => DashboardModel(
        get<ObserveUser>(),
        get<ObserveStepCount>(),
        get<StepCounterServiceInteractor>(),
      ));

  // Eager singletons must be registered in the right order
  gh.singleton<FakeStorage>(FakeStorage());
  gh.singleton<FakeUserRepository>(FakeUserRepository());
  gh.singleton<FlutterSecureStorage>(
      fakeStorageModule.flutterSecureStorage(get<FakeStorage>()),
      registerFor: {_test});
  gh.singleton<MockBeamService>(MockBeamService());
  gh.singleton<MockPaymentRemoteRepository>(MockPaymentRemoteRepository());
  gh.singleton<MockPaymentRepository>(MockPaymentRepository());
  gh.singleton<MockUserLocalDataSource>(MockUserLocalDataSource());
  gh.singleton<MockUserRemoteDataSource>(MockUserRemoteDataSource());
  return get;
}

class _$FakeStorageModule extends FakeStorageModule {}

class _$StorageModule extends StorageModule {}

class _$DataSourcesModule extends DataSourcesModule {}

class _$RepositoryModule extends RepositoryModule {}

class _$PedometerModule extends PedometerModule {}

class _$TestBeamModule extends TestBeamModule {}

class _$DataRepositoryModule extends DataRepositoryModule {}

class _$BeamModule extends BeamModule {}
