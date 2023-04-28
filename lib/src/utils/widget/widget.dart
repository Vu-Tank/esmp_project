// ignore_for_file: public_member_api_docs, sort_constructors_first
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
    errorStyle: const TextStyle(
      color: Colors.red,
      fontSize: 15,
    ),
    labelText: hintText,
    labelStyle: const TextStyle(
      color: Colors.grey,
      fontSize: 18,
    ),
  );
}

List<String> listBank = <String>[
  'ABBank',
  'ACB',
  'Agribank',
  'Bắc Á',
  'Bản Việt',
  'Bảo Việt',
  'Eximbank',
  'HDBank',
  'Indovina',
  'KienlongBank',
  'MBBank',
  'MSB',
  'Nam A Bank',
  'OCB',
  'OceanBank',
  'PVcomBank',
  'SacomBank',
  'SaigonBank',
  'SCB',
  'SeABank',
  'SHB',
  'Shinhan',
  'Techcombank',
  'Timo',
  'TPBank',
  'Việt - Nga',
  'VietBank',
  'VietcomBank',
  'ViettinBank',
  'VPBank',
  'VIB',
];
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
  fontSize: 18,
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
Color mainColor = const Color(0xFFeb6440);
Color btnColor = const Color(0xFFeb6440);
Future<String?> showMyAlertDialog(BuildContext context, String msg) async {
  String? result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: Text(
            msg,
            style: textStyleInput,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Thoát',
                style: TextStyle(color: btnColor, fontSize: 18),
              ),
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

Future<String?> showConfirmDialog(BuildContext context, String msg) async {
  String? result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: Text(
            msg,
            style: textStyleInput,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Không',
                style: TextStyle(color: btnColor, fontSize: 18),
              ),
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
            ),
            TextButton(
              child: Text(
                'Xác nhận',
                style: TextStyle(color: btnColor, fontSize: 18),
              ),
              onPressed: () {
                Navigator.pop(context, 'Ok');
              },
            ),
          ],
        );
      });
  return result;
}

class NewCheckBox extends StatefulWidget {
  final bool isChecked;
  final Function callBackfunction;
  const NewCheckBox({
    Key? key,
    required this.isChecked,
    required this.callBackfunction,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => CheckBoxWidgetState();
}

class CheckBoxWidgetState extends State<NewCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: widget.isChecked,
      onChanged: (value) {
        widget.callBackfunction(value);
      },
    );
  }
}
