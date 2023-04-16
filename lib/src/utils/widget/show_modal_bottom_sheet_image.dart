import 'dart:io';

import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../request_permission.dart';

Future<File?> showModalBottomSheetImage(BuildContext context) async {
  return await showModalBottomSheet<File>(
      context: context,
      builder: (context) {
        return Container(
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: <Widget>[
              const Text(
                "Chọn hình ảnh",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextButton.icon(
                    onPressed: () async {
                      if (await requestCameraPermission(context)) {
                        await pickImage(ImageSource.camera).then((value) {
                          Navigator.pop(context, value);
                        });
                      }
                    },
                    icon: Icon(
                      Icons.camera,
                      color: mainColor,
                    ),
                    label: Text(
                      "Máy ảnh",
                      style: TextStyle(color: mainColor, fontSize: 16),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      // if (await requestPhotosPermission(context)) {
                      await pickImage(ImageSource.gallery)
                          .then((value) => Navigator.pop(context, value));
                      // }
                    },
                    icon: Icon(
                      Icons.image,
                      color: mainColor,
                    ),
                    label: Text(
                      "Thư viện",
                      style: TextStyle(color: mainColor, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
}

Future<File?> pickImage(ImageSource source) async {
  try {
    final image = await ImagePicker().pickImage(source: source);
    // if (image == null) return;
    if (image != null) {
      return File(image.path);
    }
  } on PlatformException catch (e) {
    Future.error(e.toString());
  }
  return null;
}
