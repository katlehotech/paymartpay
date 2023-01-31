import 'dart:convert';
import 'dart:math';
import 'package:app/models/stitch.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:pkce/pkce.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StitchService {
  StitchService();

  Future<http.Response> getClientToken(Stitch stitch) async {
    var body = <String, String>{
      "client_id": stitch.client.id,
      "client_secret": stitch.secret.id,
      "scope": stitch.client.allowedScopes.join(" "),
      "grant_type": "client_credentials",
      "audience": "https://secure.stitch.money/connect/token",
    };

    String bodyString = body.entries
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
        .join("&");

    return http.post(Uri.parse('$stitch/token'),
        headers: <String, String>{
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: bodyString);
  }

  Future<List<int>> sha256(String verifier) async {
    // Encode the verifier string to a UTF-8 bytes array
    var msgBytes = utf8.encode(verifier);

    // Hash the message
    var hash = sha512256.convert(msgBytes);

    // Return the hash as a Uint8List
    return hash.bytes;
  }

  String base64UrlEncode(byteArray) {
    var output = base64Url.encode(byteArray);
    output = output.replaceAll("=", "");
    output = output.replaceAll("+", "-");
    output = output.replaceAll("/", "_");
    return output;
  }

  String generateRandomStateOrNonce() {
    var random = List.generate(32, (index) => Random().nextInt(32));
    return base64UrlEncode(random);
  }

  String buildAuthorizationUrl(
    Stitch stitch,
    String state,
    String nonce,
    String redirectUrl,
    PkcePair verifierChallengePair,
  ) {
    var search = {
      "client_id": stitch.client.id,
      "code_challenge": verifierChallengePair.codeChallenge,
      "code_challenge_method": "S256",
      "redirect_uri": redirectUrl,
      "scope": stitch.client.allowedScopes.join(" "),
      "response_type": "code",
      "nonce": nonce,
      "state": state,
    };
    var searchString = search.entries
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
        .join("&");
    return 'https://secure.stitch.money/connect/authorize?$searchString';
  }

  Future<http.Response> retrieveTokenUsingAuthorizationCode(Stitch stitch, String baseUrl,
      String redirectUrl, PkcePair verifierChallengePair, String code) async {
    var body = {
      "grant_type": "authorization_code",
      "client_id": stitch.client.id,
      "code": code,
      "redirect_uri": redirectUrl,
      "code_verifier": verifierChallengePair.codeVerifier,
      "client_secret": stitch.secret.value,
    };
    final bodyString = body.entries
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
        .join("&");
    final response = await http.post(Uri.parse('$baseUrl/token'),
        headers: <String, String>{
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: bodyString);
    return response;
  }

  Future<bool> goToBankLogin(String authUrl) async {
    if (await canLaunchUrlString(authUrl)) {
    return launchUrl(Uri.parse(authUrl), mode: LaunchMode.inAppWebView);
    } else {
     return throw 'Could not launch $authUrl';
    }
  }
}
