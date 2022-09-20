import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String hintText, IconData icon, String? errorText){
  return InputDecoration(
    prefixIcon: Icon(icon, color: Colors.grey, size: 20,),
    errorText: errorText,
    labelText: hintText,
    labelStyle: TextStyle(
      color: Colors.grey,
      fontSize: 15,
    ),
  );
}