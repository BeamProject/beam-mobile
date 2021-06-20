import 'dart:convert';
import 'dart:io';
import 'package:beam/features/data/fetch_data_exception.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@Injectable(env: [Environment.prod])
class BeamService {
  static const BEAM_ENDPOINT = "api.beamproject.co";
  static const HEADERS = <String, String>{
    'Content-Type': 'application/json',
  };

  Future<http.Response> get(String api, {Map<String, String>? headers}) async {
    headers?.addAll(HEADERS);
    var response;
    try {
      response = await http.get(Uri.https(BEAM_ENDPOINT, api),
          headers: headers ?? HEADERS);
    } on SocketException {
      throw FetchDataException("No connection");
    }
    return response;
  }

  Future<http.Response> post(String api,
      {Map<String, String>? headers, dynamic body}) async {
    headers?.addAll(HEADERS);
    var response;
    try {
      response = await http.post(Uri.https(BEAM_ENDPOINT, api),
          headers: headers ?? HEADERS, body: jsonEncode(body));
    } on SocketException {
      throw FetchDataException("No connection");
    }
    return response;
  }
}
