import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@Injectable(env: [Environment.prod])
class BeamService {
  static const BEAM_ENDPOINT = "api.beamproject.co";
  static const HEADERS = <String, String>{
    'Content-Type': 'application/json',
  };

  Future<http.Response> get(String api, {Map<String, String>? headers}) {
    headers?.addAll(HEADERS);
    return http.get(Uri.https(BEAM_ENDPOINT, api), headers: headers ?? HEADERS);
  }

  Future<http.Response> post(String api,
      {Map<String, String>? headers, dynamic body}) {
    headers?.addAll(HEADERS);
    return http.post(Uri.https(BEAM_ENDPOINT, api),
        headers: headers ?? HEADERS, body: jsonEncode(body));
  }
}
