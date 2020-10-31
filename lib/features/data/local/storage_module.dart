import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class StorageModule {
  @LazySingleton(env: [Environment.prod])
  FlutterSecureStorage get storage => FlutterSecureStorage();
}