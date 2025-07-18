import 'package:flutter/services.dart';

class NativePermissions {
  static const MethodChannel _channel = MethodChannel('com.neverr.permissions');
  
  static Future<bool> requestMicrophonePermission() async {
    try {
      print('🎤 Calling native iOS permission request...');
      final bool granted = await _channel.invokeMethod('requestMicrophonePermission');
      print('🎤 Native iOS permission result: $granted');
      return granted;
    } on PlatformException catch (e) {
      print('❌ Native permission request failed: ${e.message}');
      return false;
    }
  }
}