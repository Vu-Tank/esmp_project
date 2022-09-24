import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestCameraPermission(BuildContext context) async {
  PermissionStatus status = await Permission.camera.status;
  if (status.isGranted) {
    return true;
  } else if (!status.isGranted) {
    status = await Permission.camera.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Camera permission is Denied. Please go to Setting App!'),
              content: Text('1.Permissions\n' + '2. Camera\n' + '3. Allow'),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                OutlinedButton(
                  onPressed: () {
                    openAppSettings();
                    Navigator.of(context).pop();
                  },
                  child: Text('Accpet'),
                ),
              ],
            );
          });
    }
  }
  return false;
}

Future<bool> requestPhotosPermission() async {
  var status = await Permission.photos.status;
  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    await Permission.photos.request();
  }
  return false;
}

Future<bool> requestLocationPermission(BuildContext context) async {
  PermissionStatus status = await Permission.location.status;
  if (status.isGranted) {
    return true;
  }else {
    status = await Permission.location.request();
    if (status.isGranted) {
      return true;
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  'Location permission is Denied. Please go to Setting App!'),
              content: Text('1.Permissions\n' + '2. Camera\n' + '3. Allow'),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                OutlinedButton(
                  onPressed: () {
                    openAppSettings();
                    Navigator.of(context).pop();
                  },
                  child: Text('Accpet'),
                ),
              ],
            );
          });
    }
    return false;
  }
}
