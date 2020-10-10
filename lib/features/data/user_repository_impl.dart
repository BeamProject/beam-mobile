import 'dart:async';

import 'package:beam/features/data/datasources/user_local_data_source.dart';
import 'package:beam/features/data/datasources/user_remote_data_source.dart';
import 'package:beam/features/domain/entities/login_result.dart';
import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'model/user_mapper.dart';

class UserRepositoryImpl implements UserRepository {
  static const LOGIN_TIMEOUT = const Duration(seconds: 5);
  final UserLocalDataSource _localDataSource;
  final UserRemoteDataSource _remoteDataSource;

  final _userStatusStreamController = BehaviorSubject<User>();

  UserRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Stream<User> observeUser() {
    return _userStatusStreamController.stream;
  }

  @override
  Future<LoginResult> logIn(String username, String password) async {
    final loginResult = await _remoteDataSource
        .logIn(username, password)
        .timeout(LOGIN_TIMEOUT, onTimeout: () => LoginResult.TIMEOUT);

    if (loginResult == LoginResult.SUCCESS) {
      final user = await _remoteDataSource.getUser();
      await _localDataSource.updateUser(user);
      _userStatusStreamController.sink.add(UserMapper.mapToUser(user));
    }
    return loginResult;
  }

  @override
  Future<void> logOut() async {
    await _localDataSource.removeCurrentUser();
    _userStatusStreamController.sink.add(null);
  }

  @override
  void restoreSession() async {
    var user = await _localDataSource.getUser();
    if (user != null) {
      _userStatusStreamController.sink.add(UserMapper.mapToUser(user));
    } else {
      _userStatusStreamController.sink.add(null);
    }
  }

  void dispose() {
    _userStatusStreamController.close();
  }
}
