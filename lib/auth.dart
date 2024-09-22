import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'dart:async';

class FirebaseAccessToken {
  static String firebaseMsgScope =
      "https://www.googleapis.com/auth/firebase/firebase.messaging";

  Future<String> getToken() async {
    try {
      final credentials = ServiceAccountCredentials.fromJson({
        
      });
      List<String> scopes = [
        "https://www.googleapis.com/auth/firebase.messaging"
      ];

      final client = await obtainAccessCredentialsViaServiceAccount(
          credentials, scopes, http.Client());
      final accessToken = client;
      Timer.periodic(const Duration(minutes: 59), (timer) {
        accessToken.refreshToken;
      });
      return accessToken.accessToken.data;
    } catch (e) {
      print(e);
    }
    return '';
  }
}
