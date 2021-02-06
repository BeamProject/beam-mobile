import 'dart:async';

import 'package:beam/features/data/datasources/user_local_data_source.dart';
import 'package:beam/features/data/datasources/user_remote_data_source.dart';
import 'package:beam/features/domain/entities/login_result.dart';
import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class UserRepositoryImpl implements UserRepository {
  static const LOGIN_TIMEOUT = const Duration(seconds: 30);
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
      _userStatusStreamController.sink.add(user);
    }
    return loginResult;
  }

  @override
  Future<void> logOut() async {
    // TODO: *** IMPORTANT *** Decide on a strategy for storing local data
    // Either keep every local data keyed by a user id, or wipe out all of the
    // user's data upon logout. Otherwise, when user logs out and logs in with 
    // a different account there can be data leak between two different accounts.
    // A probably safer option is to wipe all local data. It should be backed up in the
    // cloud anyway.
    await _localDataSource.removeCurrentUser();
    _userStatusStreamController.sink.add(null);
  }

  @override
  void restoreSession() async {
    var user = await _localDataSource.getUser();
    _userStatusStreamController.sink.add(user);
  }

  void dispose() {
    _userStatusStreamController.close();
  }
}
