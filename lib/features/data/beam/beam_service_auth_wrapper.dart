import 'package:beam/features/data/beam/auth_token_manager.dart';
import 'package:beam/features/data/beam/beam_service.dart';
import 'package:http/http.dart' as http;

class BeamServiceAuthWrapper {
  static const AUTHENTICATION_HEADER_KEY = "authentication";
  final AuthTokenManager _authTokenManager;
  final BeamService _beamService;

  BeamServiceAuthWrapper(this._authTokenManager, this._beamService);

  Future<http.Response> get(String api) async {
    final authHeader = await _authTokenManager.getAuthHeader();
    return _beamService
        .get(api, headers: {AUTHENTICATION_HEADER_KEY: authHeader});
  }

  Future<http.Response> post(String api, {dynamic body}) async {
    final authHeader = await _authTokenManager.getAuthHeader();
    return _beamService.post(api,
        headers: {AUTHENTICATION_HEADER_KEY: authHeader}, body: body);
  }
}
