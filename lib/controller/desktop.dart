import 'dart:io';

import 'package:url_launcher/url_launcher.dart';
import 'package:window_to_front/window_to_front.dart';

class FlutterWebAuthDesktop {
  HttpServer? _codeListenerServer;
  static const String htmlResponsePayload =
      "<!DOCTYPE html><title>Authentication Completed</title><p>Please close the window</p><script>window.close();</script></html>";

  Future<Uri> authenticate(Uri authorizationUrl, int localPort) async {
    await _codeListenerServer?.close();
    _codeListenerServer = await HttpServer.bind('localhost', localPort);

    await _launchAuth(authorizationUrl);
    // mettere un timeout
    return await _listenAuthCode();
  }

  Future<void> _launchAuth(Uri authorizationUrl) async {
    if (await canLaunchUrl(authorizationUrl)) {
      await launchUrl(authorizationUrl);
    } else {
      throw Exception('Could not launch $authorizationUrl');
    }
  }

  Future<Uri> _listenAuthCode() async {
    var request = await _codeListenerServer!.first;
    var responseUrl = request.requestedUri;

    request.response.statusCode = 200;
    request.response.headers.set('content-type', 'text/html');
    request.response.writeln(htmlResponsePayload);

    await request.response.close();
    await _codeListenerServer!.close();
    await WindowToFront.activate();
    _codeListenerServer = null;
    return responseUrl;
  }
}
