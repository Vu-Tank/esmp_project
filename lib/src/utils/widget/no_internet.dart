import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Scaffold noInternet() {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Lỗi kết nối mạng. Vui lòng kiểm ra lại internet!!!!"),
          OutlinedButton(onPressed: (){
            AppSettings.openWIFISettings();
          }, child: Text("Cài đạt mạng")),
        ],
      ),
    ),
  );
}
