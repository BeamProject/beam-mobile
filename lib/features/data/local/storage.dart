import 'package:beam/features/data/datasources/user_local_data_source.dart';
import 'package:beam/features/data/model/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage implements UserLocalDataSource {
 
  final FlutterSecureStorage _storage;

  Storage(this._storage);
  
  @override
  Future<User> getUser() async {
    final all = await _storage.readAll();
    final id = all['id'];
    final username = all['current_username'];
    final authToken = all['auth_token'];
    if (id == null || username == null || authToken == null) {
      return null;
    }
    return User(id: int.parse(id), username: username, authToken: authToken);
  }

  @override
  Future<void> updateUser(User user) {
    var futures = <Future>[];
    futures.add(_storage.write(key: 'id', value: user.id.toString()));
    futures.add(_storage.write(key: 'current_username', value: user.username));
    futures.add(_storage.write(key: 'auth_token', value: user.authToken));
    return Future.wait(futures);
  }

  @override
  Future<void> removeCurrentUser() {
    var futures = <Future>[];
    futures.add(_storage.delete(key: 'id'));
    futures.add(_storage.delete(key: 'current_username'));
    futures.add(_storage.delete(key: 'auth_token'));
    return Future.wait(futures);
  }

}