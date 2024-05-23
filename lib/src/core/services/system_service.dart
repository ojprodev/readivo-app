import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class SystemService{

  /// A function to retrieve the Android SDK version of the device.
  ///
  /// This function returns the Android SDK version as an integer.
  /// If the platform is not Android, it throws an [UnsupportedError].
  static Future<int> getAndroidSdkVersion() async {
    // Check if the current platform is Android
    if (Platform.isAndroid) {
      // Create an instance of DeviceInfoPlugin
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      // Get the device information for Android
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // Return the Android SDK version as an integer
      return androidInfo.version.sdkInt;
    }
    // If the platform is not Android, throw an UnsupportedError
    throw UnsupportedError("Platform is not Android");
  }
}