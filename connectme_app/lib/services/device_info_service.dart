import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _plugin = DeviceInfoPlugin();

  Future<String> readDeviceInfo() async {
    if (kIsWeb) {
      final info = await _plugin.webBrowserInfo;
      return '${info.browserName.name} browser';
    }
    if (Platform.isAndroid) {
      final info = await _plugin.androidInfo;
      return '${info.manufacturer} ${info.model} • Android ${info.version.release}';
    }
    if (Platform.isIOS) {
      final info = await _plugin.iosInfo;
      return '${info.name} • iOS ${info.systemVersion}';
    }
    if (Platform.isWindows) {
      final info = await _plugin.windowsInfo;
      return 'Windows ${info.displayVersion}';
    }
    if (Platform.isMacOS) {
      final info = await _plugin.macOsInfo;
      return 'macOS ${info.osRelease}';
    }
    if (Platform.isLinux) {
      final info = await _plugin.linuxInfo;
      return info.prettyName;
    }
    return 'Device information unavailable';
  }
}
