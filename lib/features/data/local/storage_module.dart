import 'package:beam/features/data/datasources/payments_local_data_source.dart';
import 'package:beam/features/data/datasources/profile_local_data_source.dart';
import 'package:beam/features/data/datasources/settings_local_data_source.dart';
import 'package:beam/features/data/datasources/steps/step_counter_local_data_source.dart';
import 'package:beam/features/data/local/payments_storage.dart';
import 'package:beam/features/data/local/profile_storage.dart';
import 'package:beam/features/data/local/settings_storage.dart';
import 'package:beam/features/data/local/step_counter_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class StorageModule {
  @LazySingleton(env: [Environment.prod])
  FlutterSecureStorage get storage => FlutterSecureStorage();

  @Injectable(env: [Environment.prod])
  StepCounterLocalDataSource stepCounterLocalDataSource(
          StepCounterStorage stepCounterStorage) =>
      stepCounterStorage;

  @Injectable(env: [Environment.prod])
  PaymentsLocalDataSource paymentsLocalDataSource(
          PaymentsStorage paymentsStorage) =>
      paymentsStorage;

  @injectable
  SettingsLocalDataSource settingsLocalDataSource(
          SettingsStorage settingsStorage) =>
      settingsStorage;

  @injectable
  ProfileLocalDataSource profileLocalDataSource(
          ProfileStorage profileStorage) =>
      profileStorage;
}
