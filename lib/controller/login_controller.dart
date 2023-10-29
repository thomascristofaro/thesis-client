import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oauth2/oauth2.dart';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thesis_client/controller/desktop.dart';
import 'package:thesis_client/controller/utility.dart';

class UserModel {
  String username;
  String email;

  UserModel({required this.username, required this.email});

  UserModel.fromJson(Map<String, dynamic> json)
      : username = json['cognito:username'],
        email = json['email'];
}

class LoginController extends ChangeNotifier {
  static final LoginController _instance = LoginController._internal();

  final endpoint = 'https://ngb197hjce.auth.us-east-1.amazoncognito.com';
  final identifier = '2pe0l6gusm46o3ufanlkahm1s5';
  final secret = null;
  final callbackUrlScheme = 'foobar';
  final portLocalhost = 63215;

  Credentials? credentials;
  UserModel? user;

  factory LoginController() {
    return _instance;
  }

  LoginController._internal() {
    user = UserModel(username: '', email: '');
  }

  void _loadUserFromIdToken() {
    if (credentials != null) {
      Map<String, dynamic> decodedToken =
          JwtDecoder.decode(credentials!.idToken!);
      user = UserModel.fromJson(decodedToken);
    }
  }

  void _saveCredentialsToStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('credentials', credentials!.toJson());
  }

  Future<bool> _loadCredentialsFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? credStr = prefs.getString('credentials');
    if (credStr != null) {
      credentials = Credentials.fromJson(credStr);
      if (credentials!.isExpired) {
        if (credentials!.canRefresh) {
          try {
            credentials = await credentials!.refresh();
          } catch (e) {
            return false;
          }
          return true;
        } else {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  Future<void> _loadCredentialsFromAuth() async {
    Uri authorizationEndpoint = Uri.parse('$endpoint/oauth2/authorize');
    Uri tokenEndpoint = Uri.parse('$endpoint/oauth2/token');
    Uri responseUrl = Uri();
    Uri redirectUrl = buildRedirectUrl('login');

    var grant = AuthorizationCodeGrant(
        identifier, authorizationEndpoint, tokenEndpoint,
        secret: secret);
    Uri authorizationUrl = grant.getAuthorizationUrl(redirectUrl);
    responseUrl = await _callExternalUrl(authorizationUrl);
    credentials =
        (await grant.handleAuthorizationResponse(responseUrl.queryParameters))
            .credentials;
  }

  Future<Uri> _callExternalUrl(Uri authorizationUrl) async {
    if (!Utility.isWeb() && Utility.isDesktop()) {
      return await FlutterWebAuthDesktop()
          .authenticate(authorizationUrl, portLocalhost);
    } else {
      return Uri.parse(await FlutterWebAuth.authenticate(
          url: authorizationUrl.toString(),
          callbackUrlScheme: callbackUrlScheme));
    }
  }

  bool isLogged() {
    return credentials != null;
  }

  void checkLogged() {
    if (!isLogged()) throw Exception('Not logged in');
  }

  Future<bool> loginOnlyStorage() async {
    if (isLogged()) return true;

    if (await _loadCredentialsFromStorage()) {
      if (credentials != null) {
        _saveCredentialsToStorage();
        _loadUserFromIdToken();
        return true;
      }
    }
    return false;
  }

  Future<void> login() async {
    if (isLogged()) return;

    if (!await _loadCredentialsFromStorage()) await _loadCredentialsFromAuth();

    if (credentials != null) {
      _saveCredentialsToStorage();
      _loadUserFromIdToken();
    }
    notifyListeners();
  }

  void logout() async {
    credentials = null;
    user = UserModel(username: '', email: '');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('credentials');

    Uri redirectUrl = buildRedirectUrl('logout');

    await _callExternalUrl(Uri.parse('$endpoint/logout?client_id=$identifier'
        '&logout_uri=${redirectUrl.toString()}'));
    notifyListeners();
  }

  Uri buildRedirectUrl(String suffix) {
    Uri redirectUrl;

    if (Utility.isWeb()) {
      redirectUrl = Uri.parse(
          'https://thomascristofaro.github.io/thesis-client/auth.html');
      // redirectUrl = Uri.parse('http://localhost:6060/auth.html');
    } else if (Utility.isDesktop()) {
      redirectUrl = Uri.parse('http://localhost:$portLocalhost/$suffix');
    } else {
      redirectUrl = Uri.parse('$callbackUrlScheme://$suffix');
    }

    return redirectUrl;
  }
}
