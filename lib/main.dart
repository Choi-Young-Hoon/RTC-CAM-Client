import 'package:flutter/material.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webrtcapp/screen/home_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.systemAlertWindow.request();
  await Permission.camera.request();
  await Permission.microphone.request();


  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
