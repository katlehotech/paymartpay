class Token {
  final String idToken;
  final String accessToken;
  final int expiresIn;
  final String tokenType;
  final String refreshToken;
  final String scope;

  Token({required this.idToken, required this.accessToken, required this.expiresIn, required this.tokenType, required this.refreshToken, required this.scope});

  factory Token.fromJson(json) {
    return Token(
        idToken: json['id_token'],
        accessToken: json['access_token'],
        expiresIn: json['expires_in'],
        tokenType: json['token_type'],
        refreshToken: json['refresh_token'],
        scope: json['scope']
    );
  }
}