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
    } else if(status.isPermanentlyDenied) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  'Quyền Truy cập vị trí bị từ chối. Hãy đén cài đặt ứng dụng!'),
              content: Text('1.Cấp quyền\n' + '2. Vị trí\n' + '3. Cho phép'),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();

                  },
                  child: Text('Thoát'),
                ),
                OutlinedButton(
                  onPressed: () {
                    openAppSettings();
                    Navigator.of(context).pop();
                  },
                  child: Text('Đến cài đặt'),
                ),
              ],
            );
          });
    }
    return false;
  }
}
