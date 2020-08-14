import 'dart:async';

import 'package:beam/features/data/datasources/user_local_data_source.dart';
import 'package:beam/features/data/datasources/user_remote_data_source.dart';
import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/repositories/user_repository.dart';

import 'model/user_mapper.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource _localDataSource;
  final UserRemoteDataSource _remoteDataSource;

  final _userStatusStreamController = StreamController<User>();

  UserRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Stream<User> observeUser() {
    return _userStatusStreamController.stream;
  }

  @override
  Future<void> logInWithEmailAndPassword(
      String username, String password) async {
    final user =
        await _remoteDataSource.logInWithEmailAndPassword(username, password);
    if (user?.authToken != null) {
      await _localDataSource.updateUser(user);
      _userStatusStreamController.sink.add(UserMapper.mapToUser(user));
    } else {
      _userStatusStreamController.sink.add(null);
    }
  }

  @override
  Future<void> logOut() async {
    await _localDataSource.removeCurrentUser();
    _userStatusStreamController.sink.add(null);
  }

  @override
  void restoreSession() async {
    final user = await _localDataSource.getUser();
    if (user?.authToken != null) {
      _userStatusStreamController.sink.add(UserMapper.mapToUser(user));
    } else {
      _userStatusStreamController.sink.add(null);
    }
  }

  void dispose() {
    _userStatusStreamController.close();
  }
}
