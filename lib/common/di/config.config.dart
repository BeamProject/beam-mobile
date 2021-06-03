// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../features/data/beam/auth_storage.dart' as _i25;
import '../../features/data/beam/auth_token_manager.dart' as _i26;
import '../../features/data/beam/beam_payment_repository.dart' as _i47;
import '../../features/data/beam/beam_service.dart' as _i3;
import '../../features/data/beam/beam_service_auth_wrapper.dart' as _i29;
import '../../features/data/beam/beam_user_repository.dart' as _i30;
import '../../features/data/beam/inject/beam_module.dart' as _i64;
import '../../features/data/beam/testing/test_beam_module.dart' as _i60;
import '../../features/data/beam/testing/test_beam_module.mocks.dart' as _i28;
import '../../features/data/datasources/payments_local_data_source.dart' as _i7;
import '../../features/data/datasources/payments_remote_data_source.dart'
    as _i9;
import '../../features/data/datasources/profile_local_data_source.dart' as _i42;
import '../../features/data/datasources/settings_local_data_source.dart'
    as _i44;
import '../../features/data/datasources/steps/step_counter_local_data_source.dart'
    as _i13;
import '../../features/data/datasources/testing/datasources_module.dart'
    as _i62;
import '../../features/data/datasources/testing/datasources_module.mocks.dart'
    as _i8;
import '../../features/data/datasources/user_local_data_source.dart' as _i19;
import '../../features/data/datasources/user_remote_data_source.dart' as _i21;
import '../../features/data/inject/repository_module.dart' as _i63;
import '../../features/data/local/payments_storage.dart' as _i10;
import '../../features/data/local/profile_storage.dart' as _i11;
import '../../features/data/local/settings_storage.dart' as _i12;
import '../../features/data/local/step_counter_storage.dart' as _i15;
import '../../features/data/local/storage_module.dart' as _i59;
import '../../features/data/local/testing/fake_storage.dart' as _i57;
import '../../features/data/local/testing/test_storage_module.dart' as _i58;
import '../../features/data/local/user_storage.dart' as _i20;
import '../../features/data/payment_repository_impl.dart' as _i39;
import '../../features/data/pedometer/pedometer_module.dart' as _i65;
import '../../features/data/pedometer/pedometer_service.dart' as _i48;
import '../../features/data/pedometer/step_tracker.dart' as _i45;
import '../../features/data/profile_repository_impl.dart' as _i43;
import '../../features/data/step_counter_repository_impl.dart' as _i14;
import '../../features/data/user_repository_impl.dart' as _i24;
import '../../features/domain/repositories/payment_repository.dart' as _i5;
import '../../features/domain/repositories/profile_repository.dart' as _i49;
import '../../features/domain/repositories/step_counter_service.dart' as _i50;
import '../../features/domain/repositories/steps_repository.dart' as _i16;
import '../../features/domain/repositories/testing/fake_user_repository.dart'
    as _i23;
import '../../features/domain/repositories/testing/repository_module.dart'
    as _i61;
import '../../features/domain/repositories/testing/repository_module.mocks.dart'
    as _i6;
import '../../features/domain/repositories/user_repository.dart' as _i22;
import '../../features/domain/usecases/auto_log_in.dart' as _i27;
import '../../features/domain/usecases/get_current_user.dart' as _i38;
import '../../features/domain/usecases/get_daily_step_count.dart' as _i31;
import '../../features/domain/usecases/get_daily_step_count_goal.dart' as _i53;
import '../../features/domain/usecases/get_daily_step_count_range.dart' as _i32;
import '../../features/domain/usecases/get_donation_goal.dart' as _i52;
import '../../features/domain/usecases/get_last_step_count_measurement.dart'
    as _i33;
import '../../features/domain/usecases/log_in.dart' as _i34;
import '../../features/domain/usecases/log_out.dart' as _i35;
import '../../features/domain/usecases/make_delayed_payment.dart' as _i37;
import '../../features/domain/usecases/observe_step_count.dart' as _i54;
import '../../features/domain/usecases/payments_interactor.dart' as _i40;
import '../../features/domain/usecases/step_counter_service_interactor.dart'
    as _i51;
import '../../features/domain/usecases/update_daily_step_count.dart' as _i17;
import '../../features/domain/usecases/update_last_step_count_measurement.dart'
    as _i18;
import '../../features/presentation/auth/auth_bloc.dart' as _i46;
import '../../features/presentation/login/bloc/login_bloc.dart' as _i36;
import '../../features/presentation/payments/model/payments_model.dart' as _i41;
import '../../features/presentation/profile/model/profile_model.dart' as _i55;
import '../../features/presentation/settings/settings_model.dart' as _i56;

const String _prod = 'prod';
const String _test = 'test';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final fakeStorageModule = _$FakeStorageModule();
  final storageModule = _$StorageModule();
  final testBeamModule = _$TestBeamModule();
  final repositoryModule = _$RepositoryModule();
  final dataSourcesModule = _$DataSourcesModule();
  final dataRepositoryModule = _$DataRepositoryModule();
  final beamModule = _$BeamModule();
  final pedometerModule = _$PedometerModule();
  gh.factory<_i3.BeamService>(() => _i3.BeamService(), registerFor: {_prod});
  gh.lazySingleton<_i4.FlutterSecureStorage>(() => storageModule.storage,
      registerFor: {_prod});
  gh.factory<_i5.PaymentRepository>(
      () =>
          repositoryModule.paymentRepository(get<_i6.MockPaymentRepository>()),
      registerFor: {_test});
  gh.factory<_i7.PaymentsLocalDataSource>(
      () => dataSourcesModule
          .paymentsLocalDataSource(get<_i8.MockPaymentsLocalDataSource>()),
      registerFor: {_test});
  gh.factory<_i9.PaymentsRemoteDataSource>(
      () => dataSourcesModule
          .paymentsRemoteDataSource(get<_i8.MockPaymentsRemoteDataSource>()),
      registerFor: {_test});
  gh.lazySingleton<_i10.PaymentsStorage>(() => _i10.PaymentsStorage());
  gh.factory<_i11.ProfileStorage>(() => _i11.ProfileStorage());
  gh.factory<_i12.SettingsStorage>(() => _i12.SettingsStorage());
  gh.factory<_i13.StepCounterLocalDataSource>(
      () => dataSourcesModule.stepCounterLocalDataSource(
          get<_i8.MockStepCounterLocalDataSource>()),
      registerFor: {_test});
  gh.lazySingleton<_i14.StepCounterRepositoryImpl>(() =>
      _i14.StepCounterRepositoryImpl(get<_i13.StepCounterLocalDataSource>()));
  gh.lazySingleton<_i15.StepCounterStorage>(() => _i15.StepCounterStorage());
  gh.factory<_i16.StepsRepository>(() => dataRepositoryModule
      .stepCounterRepository(get<_i14.StepCounterRepositoryImpl>()));
  gh.factory<_i17.UpdateDailyStepCount>(
      () => _i17.UpdateDailyStepCount(get<_i16.StepsRepository>()));
  gh.factory<_i18.UpdateLastStepCountMeasurement>(
      () => _i18.UpdateLastStepCountMeasurement(get<_i16.StepsRepository>()));
  gh.factory<_i19.UserLocalDataSource>(
      () => _i20.UserStorage(get<_i4.FlutterSecureStorage>()),
      registerFor: {_prod});
  gh.factory<_i19.UserLocalDataSource>(
      () => dataSourcesModule
          .userLocalDataSource(get<_i8.MockUserLocalDataSource>()),
      registerFor: {_test});
  gh.factory<_i21.UserRemoteDataSource>(
      () => dataSourcesModule
          .userRemoteDataSource(get<_i8.MockUserRemoteDataSource>()),
      registerFor: {_test});
  gh.factory<_i22.UserRepository>(
      () => repositoryModule.userRepository(get<_i23.FakeUserRepository>()),
      registerFor: {_test});
  gh.lazySingleton<_i24.UserRepositoryImpl>(() => _i24.UserRepositoryImpl(
      get<_i19.UserLocalDataSource>(), get<_i21.UserRemoteDataSource>()));
  gh.factory<_i25.AuthStorage>(
      () => _i25.AuthStorage(get<_i4.FlutterSecureStorage>()));
  gh.lazySingleton<_i26.AuthTokenManager>(
      () => _i26.AuthTokenManager(get<_i25.AuthStorage>()));
  gh.factory<_i27.AutoLogIn>(() => _i27.AutoLogIn(get<_i22.UserRepository>()));
  gh.factory<_i3.BeamService>(
      () => testBeamModule.beamService(get<_i28.MockBeamService>()),
      registerFor: {_test});
  gh.factory<_i29.BeamServiceAuthWrapper>(() => _i29.BeamServiceAuthWrapper(
      get<_i26.AuthTokenManager>(), get<_i3.BeamService>()));
  gh.factory<_i30.BeamUserRepository>(() => _i30.BeamUserRepository(
      get<_i29.BeamServiceAuthWrapper>(),
      get<_i3.BeamService>(),
      get<_i26.AuthTokenManager>()));
  gh.factory<_i31.GetDailyStepCount>(
      () => _i31.GetDailyStepCount(get<_i16.StepsRepository>()));
  gh.factory<_i32.GetDailyStepCountRange>(
      () => _i32.GetDailyStepCountRange(get<_i16.StepsRepository>()));
  gh.factory<_i33.GetLastStepCountMeasurement>(
      () => _i33.GetLastStepCountMeasurement(get<_i16.StepsRepository>()));
  gh.factory<_i34.LogIn>(() => _i34.LogIn(get<_i22.UserRepository>()));
  gh.factory<_i35.LogOut>(() => _i35.LogOut(get<_i22.UserRepository>()));
  gh.factory<_i36.LoginCubit>(() => _i36.LoginCubit(get<_i34.LogIn>()));
  gh.factory<_i37.MakeDelayedPayment>(() => _i37.MakeDelayedPayment(
      get<_i5.PaymentRepository>(), get<_i22.UserRepository>()));
  gh.factory<_i38.ObserveUser>(
      () => _i38.ObserveUser(get<_i22.UserRepository>()));
  gh.factory<_i39.PaymentRepositoryImpl>(() => _i39.PaymentRepositoryImpl(
      get<_i9.PaymentsRemoteDataSource>(), get<_i7.PaymentsLocalDataSource>()));
  gh.factory<_i40.PaymentsInteractor>(() => _i40.PaymentsInteractor(
      get<_i5.PaymentRepository>(), get<_i22.UserRepository>()));
  gh.factory<_i7.PaymentsLocalDataSource>(
      () => storageModule.paymentsLocalDataSource(get<_i10.PaymentsStorage>()),
      registerFor: {_prod});
  gh.factory<_i41.PaymentsModel>(
      () => _i41.PaymentsModel(get<_i40.PaymentsInteractor>()));
  gh.factory<_i42.ProfileLocalDataSource>(
      () => storageModule.profileLocalDataSource(get<_i11.ProfileStorage>()));
  gh.factory<_i43.ProfileRepositoryImpl>(
      () => _i43.ProfileRepositoryImpl(get<_i42.ProfileLocalDataSource>()));
  gh.factory<_i44.SettingsLocalDataSource>(
      () => storageModule.settingsLocalDataSource(get<_i12.SettingsStorage>()));
  gh.factory<_i13.StepCounterLocalDataSource>(
      () => storageModule
          .stepCounterLocalDataSource(get<_i15.StepCounterStorage>()),
      registerFor: {_prod});
  gh.lazySingleton<_i45.StepTracker>(
      () => _i45.StepTracker(get<_i31.GetDailyStepCount>()));
  gh.factory<_i21.UserRemoteDataSource>(
      () => beamModule.userRemoteDataSource(get<_i30.BeamUserRepository>()),
      registerFor: {_prod});
  gh.factory<_i22.UserRepository>(
      () => dataRepositoryModule.userRepository(get<_i24.UserRepositoryImpl>()),
      registerFor: {_prod});
  gh.factory<_i46.AuthCubit>(() => _i46.AuthCubit(
      get<_i38.ObserveUser>(), get<_i35.LogOut>(), get<_i27.AutoLogIn>()));
  gh.factory<_i47.BeamPaymentRepository>(
      () => _i47.BeamPaymentRepository(get<_i29.BeamServiceAuthWrapper>()));
  gh.factory<_i5.PaymentRepository>(
      () => dataRepositoryModule
          .paymentRepository(get<_i39.PaymentRepositoryImpl>()),
      registerFor: {_prod});
  gh.factory<_i9.PaymentsRemoteDataSource>(
      () =>
          beamModule.paymentRemoteRepository(get<_i47.BeamPaymentRepository>()),
      registerFor: {_prod});
  gh.lazySingleton<_i48.PedometerService>(() => _i48.PedometerService(
      get<_i44.SettingsLocalDataSource>(),
      get<_i18.UpdateLastStepCountMeasurement>()));
  gh.factory<_i49.ProfileRepository>(
      () => dataRepositoryModule
          .profileRepository(get<_i43.ProfileRepositoryImpl>()),
      registerFor: {_prod});
  gh.factory<_i50.StepCounterService>(
      () => pedometerModule.stepCounterService(get<_i48.PedometerService>()),
      registerFor: {_prod});
  gh.factory<_i51.StepCounterServiceInteractor>(
      () => _i51.StepCounterServiceInteractor(get<_i50.StepCounterService>()));
  gh.factory<_i52.DonationGoalInteractor>(
      () => _i52.DonationGoalInteractor(get<_i49.ProfileRepository>()));
  gh.factory<_i53.GetDailyStepCountGoal>(
      () => _i53.GetDailyStepCountGoal(get<_i49.ProfileRepository>()));
  gh.factory<_i54.ObserveStepCount>(() => _i54.ObserveStepCount(
      get<_i50.StepCounterService>(), get<_i16.StepsRepository>()));
  gh.factory<_i55.ProfileModel>(() => _i55.ProfileModel(
      get<_i38.ObserveUser>(),
      get<_i54.ObserveStepCount>(),
      get<_i40.PaymentsInteractor>(),
      get<_i52.DonationGoalInteractor>(),
      get<_i32.GetDailyStepCountRange>(),
      get<_i53.GetDailyStepCountGoal>()));
  gh.factory<_i56.SettingsModel>(() => _i56.SettingsModel(
      get<_i51.StepCounterServiceInteractor>(),
      get<_i52.DonationGoalInteractor>()));
  gh.singleton<_i57.FakeStorage>(_i57.FakeStorage());
  gh.singleton<_i23.FakeUserRepository>(_i23.FakeUserRepository());
  gh.singleton<_i4.FlutterSecureStorage>(
      fakeStorageModule.flutterSecureStorage(get<_i57.FakeStorage>()),
      registerFor: {_test});
  gh.singleton<_i28.MockBeamService>(testBeamModule.mockBeamService,
      registerFor: {_test});
  gh.singleton<_i6.MockPaymentRepository>(
      repositoryModule.mockPaymentRepository,
      registerFor: {_test});
  gh.singleton<_i8.MockPaymentsLocalDataSource>(
      dataSourcesModule.mockPaymentsLocalDataSource,
      registerFor: {_test});
  gh.singleton<_i8.MockPaymentsRemoteDataSource>(
      dataSourcesModule.mockPaymentsRemoteDataSource,
      registerFor: {_test});
  gh.singleton<_i8.MockStepCounterLocalDataSource>(
      dataSourcesModule.mockStepCounterLocalDataSource,
      registerFor: {_test});
  gh.singleton<_i8.MockUserLocalDataSource>(
      dataSourcesModule.mockUserLocalDataSource,
      registerFor: {_test});
  gh.singleton<_i8.MockUserRemoteDataSource>(
      dataSourcesModule.mockUserRemoteDataSource,
      registerFor: {_test});
  return get;
}

class _$FakeStorageModule extends _i58.FakeStorageModule {}

class _$StorageModule extends _i59.StorageModule {}

class _$TestBeamModule extends _i60.TestBeamModule {
  @override
  _i28.MockBeamService get mockBeamService => _i28.MockBeamService();
}

class _$RepositoryModule extends _i61.RepositoryModule {
  @override
  _i6.MockPaymentRepository get mockPaymentRepository =>
      _i6.MockPaymentRepository();
}

class _$DataSourcesModule extends _i62.DataSourcesModule {
  @override
  _i8.MockPaymentsLocalDataSource get mockPaymentsLocalDataSource =>
      _i8.MockPaymentsLocalDataSource();
  @override
  _i8.MockPaymentsRemoteDataSource get mockPaymentsRemoteDataSource =>
      _i8.MockPaymentsRemoteDataSource();
  @override
  _i8.MockStepCounterLocalDataSource get mockStepCounterLocalDataSource =>
      _i8.MockStepCounterLocalDataSource();
  @override
  _i8.MockUserLocalDataSource get mockUserLocalDataSource =>
      _i8.MockUserLocalDataSource();
  @override
  _i8.MockUserRemoteDataSource get mockUserRemoteDataSource =>
      _i8.MockUserRemoteDataSource();
}

class _$DataRepositoryModule extends _i63.DataRepositoryModule {}

class _$BeamModule extends _i64.BeamModule {}

class _$PedometerModule extends _i65.PedometerModule {}
