class Stitch {
  final Client client;
  final Secret secret;

  Stitch({
    required this.client,
    required this.secret,
  });

  factory Stitch.fromJson(Map<String, dynamic> json) {
    return Stitch(
      client: Client.fromJson(json['client']),
      secret: Secret.fromJson(json['secret']),
    );
  }
}

class Client {
  final String id;
  final String name;
  final String environment;
  final String url;
  final List<String> allowedScopes;
  final List<String> redirectUrls;
  final List<String> countryCodes;
  final int absoluteRefreshTokenLifetime;
  final int accessTokenLifetime;
  final List<String> allowedGrantTypes;
  final int authorizationCodeLifetime;
  final int identityTokenLifetime;
  final int refreshTokenUsage;
  final int slidingRefreshTokenLifetime;

  Client({
    required this.id,
    required this.name,
    required this.environment,
    required this.url,
    required this.allowedScopes,
    required this.redirectUrls,
    required this.countryCodes,
    required this.absoluteRefreshTokenLifetime,
    required this.accessTokenLifetime,
    required this.allowedGrantTypes,
    required this.authorizationCodeLifetime,
    required this.identityTokenLifetime,
    required this.refreshTokenUsage,
    required this.slidingRefreshTokenLifetime,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'],
      environment: json['environment'],
      url: json['url'],
      allowedScopes: List<String>.from(json['allowedScopes']),
      redirectUrls: List<String>.from(json['redirectUrls']),
      countryCodes: List<String>.from(json['countryCodes']),
      absoluteRefreshTokenLifetime: json['absoluteRefreshTokenLifetime'],
      accessTokenLifetime: json['accessTokenLifetime'],
      allowedGrantTypes: List<String>.from(json['allowedGrantTypes']),
      authorizationCodeLifetime: json['authorizationCodeLifetime'],
      identityTokenLifetime: json['identityTokenLifetime'],
      refreshTokenUsage: json['refreshTokenUsage'],
      slidingRefreshTokenLifetime: json['slidingRefreshTokenLifetime'],
    );
  }
}

class Secret {
  final String id;
  final String value;
  final DateTime expiration;

  Secret({
    required this.id,
    required this.value,
    required this.expiration,
  });

  factory Secret.fromJson(Map<String, dynamic> json) {
    return Secret(
      id: json['id'],
      value: json['value'],
      expiration: DateTime.parse(json['expiration']),
    );
  }
}
