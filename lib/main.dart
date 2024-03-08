import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rtccamclient/pipservice.dart';
import 'package:rtccamclient/screen/home_screen.dart';
import 'package:uni_links/uni_links.dart';

String? webViewUrl = "https://choiyh.synology.me:40001";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.systemAlertWindow.request();
  await Permission.camera.request();
  await Permission.microphone.request();

  getInitialLink().then((initialLink) {
    handleLink(initialLink);
  });

  linkStream.listen((link) {
    handleLink(link);
  }, onError: (err) {
    // Handle the error here
  });

  runApp(MaterialApp(
    home: HomeScreen(),
  ));

}

void handleLink(String? link) {
  if (link != null && link.startsWith('rtccam://')) {
    // Parse the parameters from the link
    Uri uri = Uri.parse(link);
    String? joinRoom = uri.queryParameters['join_room'];
    String? authToken = uri.queryParameters['auth_token'];

    // Construct the URL for the InAppWebView
    webViewUrl = 'https://choiyh.synology.me:40001/room?join_room=$joinRoom&auth_token=$authToken';
  } else {
    webViewUrl = 'https://choiyh.synology.me:40001';
  }
}