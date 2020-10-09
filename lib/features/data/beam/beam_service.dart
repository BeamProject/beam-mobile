import 'dart:convert';
import 'package:http/http.dart' as http;

class BeamService {
  static const BEAM_ENDPOINT = "https://api.beamproject.co";
  static const HEADERS = <String, String>{
    'Content-Type': 'application/json',
  };

  Future<http.Response> get(String api, {Map<String, String> headers}) {
    headers.addAll(HEADERS);
    return http.get(BEAM_ENDPOINT + api, headers: headers);
  }

  Future<http.Response> post(String api,
      {Map<String, String> headers, dynamic body}) {
    headers.addAll(HEADERS);
    return http.post(BEAM_ENDPOINT + api,
        headers: headers, body: jsonEncode(body));
  }
}
