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

TextStyle textStyleLabel = const TextStyle(
  color: Colors.grey,
  fontSize: 20,
);
TextStyle textStyleLabelChild = const TextStyle(
  color: Colors.grey,
  fontSize: 16,
);
TextStyle textStyleInput = const TextStyle(
  color: Colors.black,
  fontSize: 20,
);
TextStyle textStyleInputChild = const TextStyle(
  color: Colors.black,
  fontSize: 16,
);
TextStyle textStyleError = const TextStyle(
  color: Colors.red,
  fontSize: 16,
);
TextStyle appBarTextStyle = const TextStyle(
  color: Colors.white,
  fontSize: 22,
);
TextStyle btnTextStyle = const TextStyle(
  color: Colors.white,
  fontSize: 18,
);
Color mainColor= Colors.grey;
Color btnColor= Colors.grey;

Future<String?> showMyAlertDialog(BuildContext context, String msg) async {
  String? result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Text(
            msg,
            style: textStyleInput,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Thoát', style: TextStyle(color: btnColor, fontSize: 18),),
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
            ),
          ],
        );
      });
  return result;
}

Scaffold errorScreen(BuildContext context, String msg) {
  return Scaffold(
    body: Center(
      child: Column(
        children: [
          Text(msg),
          OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Thoát")),
        ],
      ),
    ),
  );
}
