import 'package:flutter/material.dart';
InputDecoration buildInputDecoration(
    String hintText, IconData icon, String? errorText) {
  return InputDecoration(
    prefixIcon: Icon(
      icon,
      color: Colors.grey,
      size: 20,
    ),
    errorText: errorText,
    errorStyle: TextStyle(
      color: Colors.red,
      fontSize: 15,
    ),
    labelText: hintText,
    labelStyle: TextStyle(
      color: Colors.grey,
      fontSize: 18,
    ),
  );
}
Widget loading= Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: const <Widget>[
    CircularProgressIndicator(),
    Text("Please wait"),
  ],
);

TextStyle textStyleLabel=const TextStyle(color: Colors.grey,fontSize: 20,);
TextStyle textStyleLabelChild=const TextStyle(color: Colors.grey,fontSize: 16,);
TextStyle textStyleInput=const TextStyle(color: Colors.black,fontSize: 20,);
TextStyle textStyleInputChild=const TextStyle(color: Colors.black,fontSize: 16,);
TextStyle textStyleError=const TextStyle(
  color: Colors.red,
  fontSize: 12,
);