import 'dart:convert';

import 'package:app/auth_gate.dart';
import 'package:app/dashboard_page.dart';
import 'package:app/firebase_options.dart';
import 'package:app/models/stitch.dart';
import 'package:app/models/token.dart';
import 'package:app/services/stitch_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pkce/pkce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_functions/cloud_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FirebaseFunctions.instance.useFunctionsEmulator('127.0.0.1', 8080);

  runApp(const MyApp());
}

Future<Map<String, dynamic>> readJson(String path) async {
  try {
    final String response = await rootBundle.loadString(path);
    Map<String, dynamic> data = json.decode(response);
    return data;
  } catch (e) {
    return Future.error(e);
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('status') == message.data['status']) {
    return;
  }
}

Future<String?> startMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: false,
    announcement: false,
    badge: false,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: false,
  );
  return messaging.getToken();
}

storeStateAndToken(String state, String token) async {
  try {
    FirebaseDatabase.instance
        .ref()
        .child('states')
        .child(state)
        .child('device_token')
        .set(token);
  } catch (e) {
    rethrow;
  }
}

Future<User?> startFirebaseAuthentication() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser;
  auth.authStateChanges().listen((User? user) {
    if (user == null) {
      try {
        //TODO: use credentials
        final userCredential = auth.signInAnonymously();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "operation-not-allowed":
            throw("Anonymous auth hasn't been enabled for this project.");
          default:
            throw("Unknown error.");
        }
      }
    } else {
      currentUser = user;
    }
  });
  return currentUser;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    // FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
    //   Navigator.pushNamed(context, dynamicLinkData.link.path);
    // }).onError((error) {
    //   throw error;
    // });
    // FirebaseAuth auth = FirebaseAuth.instance;
    // FirebaseDatabase database = FirebaseDatabase.instance;
    // const redirectUrl = 'http://127.0.0.1:8080/paymartpay/us-central1/Return';
    // const baseUrl = 'https://secure.stitch.money';
    // Stitch stitch;
    // String authUrl;
    // Token accessToken;
    // final stitchService = StitchService();
    // final state = stitchService.generateRandomStateOrNonce();
    // final nonce = stitchService.generateRandomStateOrNonce();
    // PkcePair verifierChallengePair = PkcePair.generate(length: 32);
    // readJson('assets/client.json').then((value) async {
    //   User? user = await startFirebaseAuthentication();
    //   String? token = await startMessaging();
    //   storeStateAndToken(state, token!);
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setString('device_token', token);
    //   prefs.setString('state', state);
    //   stitch = Stitch.fromJson(value);
    //   authUrl = stitchService.buildAuthorizationUrl(
    //       stitch, state, nonce, redirectUrl, verifierChallengePair);
    //   if(user != null) {
    //     database.ref('/states/$state').onChildChanged.listen((event) {
    //       Map<String, dynamic> states = Map<String, dynamic>.from(event.snapshot.value as dynamic);
    //       print({'states': states});
    //       if(states['bank_code'] != null) {
    //         stitchService
    //             .retrieveTokenUsingAuthorizationCode(stitch, baseUrl, redirectUrl,
    //             verifierChallengePair, states['bank_code'])
    //             .then((tokenResponse) {
    //           if (tokenResponse.statusCode == 200) {
    //             print({'access_token': tokenResponse.body});
    //             accessToken = Token.fromJson(tokenResponse.body);
    //           }
    //         }).catchError((onError)=> throw onError);
    //       } else {
    //         print('bank account does not exist');
    //       }
    //     });
    //   }
    //   stitchService.goToBankLogin(authUrl);
    // });

    return MaterialApp(
      title: 'PayMart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthGate(),
    );
  }
}
