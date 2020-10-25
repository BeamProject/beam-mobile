import 'package:beam/features/data/local/testing/fake_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class FakeStorageModule {
  @Singleton(env: [Environment.test])
  FlutterSecureStorage flutterSecureStorage(FakeStorage fakeStorage) =>
      fakeStorage;
}
