import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoHelper {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static Future<String> get model async {
    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      return "${info.manufacturer} ${info.model}";
    } else if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      return "${info.utsname.machine} ${info.model}";
    } else {
      return "Unknown Device";
    }
  }

  static Future<String> get version async {
    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      return "Android ${info.version.release}";
    } else if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      return "iOS ${info.systemVersion}";
    } else {
      return "Unknown OS";
    }
  }

  static String get locale {
    return PlatformDispatcher.instance.locale.toLanguageTag();
  }
}
