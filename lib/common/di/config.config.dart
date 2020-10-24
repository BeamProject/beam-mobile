// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../features/data/beam/auth_storage.dart';
import '../../features/data/beam/auth_token_manager.dart';
import '../../features/domain/usecases/auto_log_in.dart';
import '../../features/data/beam/beam_payment_repository.dart';
import '../../features/data/beam/beam_service.dart';
import '../../features/data/beam/beam_service_auth_wrapper.dart';
import '../../features/data/beam/beam_user_repository.dart';
import '../../features/domain/usecases/log_in.dart';
import '../../features/domain/usecases/log_out.dart';
import '../../features/domain/usecases/make_delayed_payment.dart';
import '../../features/domain/usecases/get_current_user.dart';
import '../../features/data/datasources/payment_remote_repository.dart';
import '../../features/domain/repositories/payment_repository.dart';
import '../../features/data/payment_repository_impl.dart';
import '../../features/data/local/storage_module.dart';
import '../../features/data/datasources/user_local_data_source.dart';
import '../../features/data/datasources/user_remote_data_source.dart';
import '../../features/domain/repositories/user_repository.dart';
import '../../features/data/user_repository_impl.dart';
import '../../features/data/local/user_storage.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  final storageModule = _$StorageModule();
  gh.factory<BeamService>(() => BeamService());
  gh.factory<UserLocalDataSource>(
      () => UserStorage(get<FlutterSecureStorage>()));
  gh.factory<AuthStorage>(() => AuthStorage(get<FlutterSecureStorage>()));
  gh.factory<BeamServiceAuthWrapper>(() =>
      BeamServiceAuthWrapper(get<AuthTokenManager>(), get<BeamService>()));
  gh.factory<PaymentRemoteRepository>(
      () => BeamPaymentRepository(get<BeamServiceAuthWrapper>()));
  gh.factory<PaymentRepository>(
      () => PaymentRepositoryImpl(get<PaymentRemoteRepository>()));
  gh.factory<UserRemoteDataSource>(() => BeamUserRepository(
        get<BeamServiceAuthWrapper>(),
        get<BeamService>(),
        get<AuthTokenManager>(),
      ));
  gh.factory<AutoLogIn>(() => AutoLogIn(get<UserRepository>()));
  gh.factory<LogIn>(() => LogIn(get<UserRepository>()));
  gh.factory<LogOut>(() => LogOut(get<UserRepository>()));
  gh.factory<MakeDelayedPayment>(() =>
      MakeDelayedPayment(get<PaymentRepository>(), get<UserRepository>()));
  gh.factory<ObserveUser>(() => ObserveUser(get<UserRepository>()));

  // Eager singletons must be registered in the right order
  gh.singleton<FlutterSecureStorage>(storageModule.storage);
  gh.singleton<AuthTokenManager>(AuthTokenManager(get<AuthStorage>()));
  gh.singleton<UserRepository>(UserRepositoryImpl(
      get<UserLocalDataSource>(), get<UserRemoteDataSource>()));
  return get;
}

class _$StorageModule extends StorageModule {}
