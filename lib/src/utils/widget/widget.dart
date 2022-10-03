import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

InputDecoration buildInputDecoration(
    String hintText, IconData icon, String? errorText) {
  return InputDecoration(
    prefixIcon: Icon(
      icon,
      color: Colors.grey,
      size: 20,
    ),
    errorText: errorText,
    labelText: hintText,
    labelStyle: TextStyle(
      color: Colors.grey,
      fontSize: 15,
    ),
  );
}
Widget loading= Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    CircularProgressIndicator(),
    Text("Please wait"),
  ],
);

TextStyle textStyle(){
  return TextStyle(
    color: Colors.grey,
    fontSize: 15,
  );
}