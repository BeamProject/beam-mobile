import 'package:beam/features/data/datasources/steps/step_counter_local_data_source.dart';
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
}
