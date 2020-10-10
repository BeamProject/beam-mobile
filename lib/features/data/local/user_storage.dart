import 'package:beam/features/data/datasources/user_local_data_source.dart';
import 'package:beam/features/domain/entities/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserStorage implements UserLocalDataSource {
  static const KEY_ID = 'id';
  static const KEY_FIRST_NAME = 'firstName';
  static const KEY_LAST_NAME = 'lastName';

  final FlutterSecureStorage _storage;

  UserStorage(this._storage);

  @override
  Future<User> getUser() async {
    final all = await _storage.readAll();
    final id = all[KEY_ID];
    final firstName = all[KEY_FIRST_NAME];
    final lastName = all[KEY_LAST_NAME];
    return User(id: id, firstName: firstName, lastName: lastName);
  }

  @override
  Future<void> updateUser(User user) {
    var futures = <Future>[];
    futures.add(_storage.write(key: KEY_ID, value: user.id));
    futures.add(_storage.write(key: KEY_FIRST_NAME, value: user.firstName));
    futures.add(_storage.write(key: KEY_LAST_NAME, value: user.lastName));
    return Future.wait(futures);
  }

  @override
  Future<void> removeCurrentUser() {
    var futures = <Future>[];
    futures.add(_storage.delete(key: KEY_ID));
    futures.add(_storage.delete(key: KEY_FIRST_NAME));
    futures.add(_storage.delete(key: KEY_LAST_NAME));
    return Future.wait(futures);
  }
}
