import 'dart:developer';

import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/screens/login_register/otp_screen.dart';
import 'package:esmp_project/src/screens/login_register/register_screen.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user/user_provider.dart';
import '../../providers/user/verify_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verifyProvider = Provider.of<VerifyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Đăng nhập",
          style: appBarTextStyle,
        )),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: <Widget>[
                //logo
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child:
                      Image(image: AssetImage('assets/images/online_shop.png')),
                ),
                TextField(
                  decoration: buildInputDecoration(
                      "Số điện thoại", Icons.phone, verifyProvider.phone.error),
                  style: textStyleInput,
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                ),
                //register
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen()));
                          },
                          child: const Text(
                            "Đăng Ký",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 15,
                            ),
                          )),
                    ],
                  ),
                ),
                //login btn
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (verifyProvider
                            .validPhoneNumber(_phoneController.text.trim())) {
                          LoadingDialog.showLoadingDialog(context, "Vui lòng đợi");
                          await verifyProvider.login(
                              phone: _phoneController.text.trim(),
                              onSendCode: (String verificationId) {
                                LoadingDialog.hideLoadingDialog(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OTPScreen(
                                              verificationId: verificationId,
                                              phone: Utils.convertToFirebase(_phoneController.text.trim()),
                                              status: 'login',
                                            )));
                              },
                              onSuccess: (UserModel user) {
                                LoadingDialog.hideLoadingDialog(context);
                                context.read<UserProvider>().setUser(user);
                                Navigator.pushReplacementNamed(
                                    context, "/main");
                              },
                              onFailed: (String msg) {
                                LoadingDialog.hideLoadingDialog(context);
                                showMyAlertDialog(context, msg);
                              });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btnColor,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      child: Text("Đăng nhập", style: btnTextStyle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
