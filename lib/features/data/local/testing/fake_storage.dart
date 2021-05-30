import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@singleton
class FakeStorage implements FlutterSecureStorage {
  final _cacheStorage = Map<String, String>();

  @override
  Future<bool> containsKey(
      {required String key,
      IOSOptions? iOptions = IOSOptions.defaultOptions,
      AndroidOptions? aOptions,
      LinuxOptions? lOptions}) {
    throw UnimplementedError();
  }

  @override
  Future<void> delete(
      {required String key,
      IOSOptions? iOptions = IOSOptions.defaultOptions,
      AndroidOptions? aOptions,
      LinuxOptions? lOptions}) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAll(
      {IOSOptions? iOptions = IOSOptions.defaultOptions,
      AndroidOptions? aOptions,
      LinuxOptions? lOptions}) async {
    _cacheStorage.clear();
  }

  @override
  Future<String?> read(
      {required String key,
      IOSOptions? iOptions = IOSOptions.defaultOptions,
      AndroidOptions? aOptions,
      LinuxOptions? lOptions}) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, String>> readAll(
      {IOSOptions? iOptions = IOSOptions.defaultOptions,
      AndroidOptions? aOptions,
      LinuxOptions? lOptions}) {
    return Future.value(_cacheStorage);
  }

  @override
  Future<void> write(
      {required String key,
      required String? value,
      IOSOptions? iOptions = IOSOptions.defaultOptions,
      AndroidOptions? aOptions,
      LinuxOptions? lOptions}) async {
    if (value != null) {
      _cacheStorage[key] = value;
    }
  }
}
