import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:thesis_client/firebase_options.dart';

class FireBaseController extends ChangeNotifier {
  static final FireBaseController _instance = FireBaseController._internal();

  String? _fcmToken;
  NotificationSettings? _notificationSettings;

  factory FireBaseController() {
    return _instance;
  }

  FireBaseController._internal();

  void askToken() {
    FirebaseMessaging.instance
        .getToken(vapidKey: DefaultFirebaseOptions.vapidKey)
        .then(setFCMToken)
        .catchError(removeFCMToken);
    FirebaseMessaging.instance.onTokenRefresh
        .listen(setFCMToken, onError: removeFCMToken);
    checkPermissions();
  }

  void requestPermissions() async {
    await FirebaseMessaging.instance.requestPermission();
    notifyListeners();
  }

  void checkPermissions() async {
    _notificationSettings =
        await FirebaseMessaging.instance.getNotificationSettings();
    notifyListeners();
  }

  String? getPermissions() {
    return _notificationSettings != null
        ? _notificationSettings!.authorizationStatus.name
        : null;
  }

  void setFCMToken(String? token) {
    _fcmToken = token;
    notifyListeners();
  }

  String? getFCMToken() {
    return _fcmToken;
  }

  void removeFCMToken(err) {
    _fcmToken = '$err'; // null
    notifyListeners();
  }
}
