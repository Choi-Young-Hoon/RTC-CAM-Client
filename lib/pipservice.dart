import 'package:flutter/services.dart';

class PIPService {
  static bool isUsagePIPMode = false;
  static const MethodChannel _channel = MethodChannel('com.choiyh.pip');

  static MethodChannel get channel => _channel;

  static Future<void> enterPIPMode() async {
    try {
      await _channel.invokeMethod('enterPIPMode');
    } on PlatformException catch (e) {
      print("Failed to enter PIP mode: '${e.message}'.");
    }
  }

  static void setPIPMode(bool isInPIPMode) async {
    try {
      await _channel.invokeMethod('setPIPMode', isInPIPMode);
    } on PlatformException catch (e) {
      print("setPIPMode Failed to enter PIP mode: '${e.message}'.");
    }
  }

}