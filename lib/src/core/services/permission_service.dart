import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:readivo_app/src/core/services/system_service.dart';

enum PermissionAction{
  check,
  request,
}

class PermissionService {
  Future<bool> requestStoragePermission() async {
    // Check if the platform is Android
    if (Platform.isAndroid) {
      Permission permission = await determineAndroidStoragePermission();
      return await handlePermissionRequest(permission);
    } else {
      print('hhh, soon. Im poor now :)');
      return false;
    }
  }

  Future<bool> checkStoragePermission() async {
    if (Platform.isAndroid) {
      Permission permission = await determineAndroidStoragePermission();
      return await permission.isGranted;
    }
    return false;
  }

  Future<bool> handlePermissionRequest(Permission permission) async {
    final status = await permission.request();
    return status == PermissionStatus.granted;
  }

  Future<Permission> determineAndroidStoragePermission() async {
    final androidSdkVersion = await SystemService.getAndroidSdkVersion();
    if (androidSdkVersion >= 33) {
      // manageExternalStorage permission if SDK version is 33 or higher
      return Permission.manageExternalStorage;
    } else {
      // storage permission if SDK version is lower than 33
      return Permission.storage;
    }
  }
}
