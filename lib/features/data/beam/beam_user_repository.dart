import 'dart:convert';

import 'package:beam/features/data/beam/auth_token_manager.dart';
import 'package:beam/features/data/beam/beam_service_auth_wrapper.dart';
import 'package:beam/features/data/beam/credentials.dart';
import 'package:beam/features/data/beam/model/user.dart' as beam;
import 'package:beam/features/data/datasources/user_remote_data_source.dart';
import 'package:beam/features/domain/entities/login_result.dart';
import 'package:beam/features/domain/entities/user.dart';

import 'beam_service.dart';
import 'model/user_mapper.dart';

class BeamUserRepository implements UserRemoteDataSource {
  static const GET_USER_API = '/user/me';
  static const LOGIN_API = '/auth/login';

  final BeamServiceAuthWrapper _beamServiceAuthWrapper;
  final BeamService _beamService;
  final AuthTokenManager _authTokenManager;

  BeamUserRepository(
      this._beamServiceAuthWrapper, this._beamService, this._authTokenManager);

  @override
  Future<LoginResult> logIn(String username, String password) async {
    final response = await _beamService
        .post(LOGIN_API, body: {"email": username, "password": password});
    if (response.statusCode == 200) {
      final credentials = Credentials.fromJson(json.decode(response.body));
      if (credentials?.authToken != null) {
        await _authTokenManager.saveCredentials(credentials);
        return LoginResult.SUCCESS;
      }
    }
    return LoginResult.ERROR;
  }

  @override
  Future<User> getUser() async {
    final response = await _beamServiceAuthWrapper.get(GET_USER_API);
    if (response.statusCode == 200) {
      return UserMapper.mapFromBeamUser(
          beam.User.fromJson(json.decode(response.body)));
    }
    return null;
  }
}
