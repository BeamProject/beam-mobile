class Credentials {
  final String authToken;
  final String refreshToken;
  final DateTime expiration;

  bool get isExpired =>
      expiration != null && DateTime.now().isAfter(expiration);

  Credentials({this.authToken, this.refreshToken, this.expiration});

  factory Credentials.fromJson(Map<String, dynamic> json) {
    DateTime expiration = (json['expiration'] is int)
        ? DateTime.fromMillisecondsSinceEpoch(json['expiration'])
        : null;
    return Credentials(
        authToken: json['token'],
        refreshToken: json['refresh_token'],
        expiration: expiration);
  }
}
