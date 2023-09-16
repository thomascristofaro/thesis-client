import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:thesis_client/firebase_options.dart';

class FireBaseController extends ChangeNotifier {
  static final FireBaseController _instance = FireBaseController._internal();

  String? _fcmToken;

  factory FireBaseController() {
    return _instance;
  }

  FireBaseController._internal();

  void initToken() {
    FirebaseMessaging.instance
        .getToken(vapidKey: DefaultFirebaseOptions.vapidKey)
        .then(setFCMToken);
    FirebaseMessaging.instance.onTokenRefresh.listen(setFCMToken);
  }

  void setFCMToken(String? token) {
    _fcmToken = token;
    notifyListeners();
  }

  String? getFCMToken() {
    return _fcmToken;
  }
}
