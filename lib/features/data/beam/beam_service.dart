import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@injectable
class BeamService {
  static const BEAM_ENDPOINT = "https://api.beamproject.co";
  static const HEADERS = <String, String>{
    'Content-Type': 'application/json',
  };

  Future<http.Response> get(String api, {Map<String, String> headers}) {
    headers?.addAll(HEADERS);
    return http.get(BEAM_ENDPOINT + api, headers: headers ?? HEADERS);
  }

  Future<http.Response> post(String api,
      {Map<String, String> headers, dynamic body}) {
    headers?.addAll(HEADERS);
    return http.post(BEAM_ENDPOINT + api,
        headers: headers ?? HEADERS, body: jsonEncode(body));
  }
}
