import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FakeStorage implements FlutterSecureStorage {
  final _cacheStorage = Map<String, String>();

  @override
  Future<bool> containsKey(
      {String key, IOSOptions iOptions, AndroidOptions aOptions}) {
    throw UnimplementedError();
  }

  @override
  Future<void> delete(
      {String key, IOSOptions iOptions, AndroidOptions aOptions}) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAll({IOSOptions iOptions, AndroidOptions aOptions}) {
    _cacheStorage.clear();
  }

  @override
  Future<String> read(
      {String key, IOSOptions iOptions, AndroidOptions aOptions}) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, String>> readAll(
      {IOSOptions iOptions, AndroidOptions aOptions}) {
    return Future.value(_cacheStorage);
  }

  @override
  Future<void> write(
      {String key,
      String value,
      IOSOptions iOptions,
      AndroidOptions aOptions}) async {
    _cacheStorage[key] = value;
  }
}
