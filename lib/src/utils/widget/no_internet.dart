import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

Scaffold noInternet() {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Lỗi kết nối mạng. Vui lòng kiểm ra lại internet!!!!"),
          OutlinedButton(onPressed: (){
            AppSettings.openWIFISettings();
          }, child: const Text("Cài đạt mạng")),
        ],
      ),
    ),
  );
}
