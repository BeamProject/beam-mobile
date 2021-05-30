import 'package:equatable/equatable.dart';

class Credentials extends Equatable {
  static const AUTH_TOKEN_KEY = "token";
  static const REFRESH_TOKEN_KEY = "refresh_token";
  static const EXPIRATION_KEY = "expiration";

  final String authToken;
  final String? refreshToken;
  final DateTime? expiration;

  bool get isExpired =>
      expiration != null && DateTime.now().isAfter(expiration!);

  Credentials({required this.authToken,  this.refreshToken, this.expiration});

  factory Credentials.fromJson(Map<String, dynamic> json) {
    DateTime? expiration = (json[EXPIRATION_KEY] is int)
        ? DateTime.fromMillisecondsSinceEpoch(json[EXPIRATION_KEY])
        : null;
    return Credentials(
        authToken: json[AUTH_TOKEN_KEY],
        refreshToken: json[REFRESH_TOKEN_KEY],
        expiration: expiration);
  }

  @override
  List<Object?> get props => [authToken, refreshToken, expiration];
}
