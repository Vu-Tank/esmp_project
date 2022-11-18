import 'dart:async';
import 'dart:developer';

import 'package:esmp_project/src/screens/login_register/register_info_screen.dart';
import 'package:esmp_project/src/screens/main/main_screen.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../providers/user/user_provider.dart';
import '../../providers/user/verify_provider.dart';
import '../../utils/widget/showSnackBar.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key, required this.phone, required this.status, required this.verificationId})
      : super(key: key);
  final String verificationId;
  final String phone;
  final String status;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool _isResendOTP = true;
  String? _otpCode = '';
  late Timer _timer;
  int _start = 60;

  void reSend() {
    setState(() {
      _isResendOTP = true;
    });
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start == 0) {
          _start = 60;
          _isResendOTP = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    reSend();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VerifyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Xác thực',
          style: appBarTextStyle,
        )),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child:
                      Image(image: AssetImage('assets/images/online_shop.png')),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("Xác Thực OTP",
                      style: Theme.of(context).textTheme.headline6),
                ),
                Text(
                  'Số điện thoại ${widget.phone}',
                  style: Theme.of(context).textTheme.headline6,
                ),
                PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  appContext: context,
                  onChanged: (value) {},
                  onCompleted: (value) {
                    setState(() {
                      _otpCode = value;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Không nhận được OTP?",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    TextButton(
                        onPressed: () async {
                          if (_isResendOTP) return;
                          await provider.verifyPhone(
                              phoneNumber: widget.phone,
                              status: widget.status,
                              onFailed: (String msg) {
                                showMyAlertDialog(context, msg);
                              },
                              onLogin: (UserModel user) {
                                context.read<UserProvider>().setUser(user);
                                Navigator.pushReplacementNamed(
                                    context, "/main");
                              },
                              onRegister: (String token, String? uid) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterInfoScreen(
                                              token: token,
                                              phone: widget.phone,
                                              uid: uid,
                                            )));
                              },
                              onSendCode: () {});
                          reSend();
                        },
                        child: Text(
                          _isResendOTP ? "Thử lại sau $_start s" : "Gửi lại",
                          style: const TextStyle(
                              color: Colors.blueAccent, fontSize: 16),
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_otpCode!.length == 6) {
                          LoadingDialog.showLoadingDialog(
                              context, "Vui lòng đợi");
                          await provider.verifyOTP(
                              otp: _otpCode!,
                              phoneNumber: widget.phone,
                              verificationId: widget.verificationId,
                              status: widget.status,
                              onFailed: (String msg) {
                                LoadingDialog.hideLoadingDialog(context);
                                // showSnackBar(context, msg);
                                showMyAlertDialog(context, msg);
                              },
                              onLogin: (UserModel user) {
                                context.read<UserProvider>().setUser(user);
                                LoadingDialog.hideLoadingDialog(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainScreen()));
                              },
                              onRegister: (String token, String? uid) {
                                LoadingDialog.hideLoadingDialog(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterInfoScreen(
                                              token: token,
                                              phone: widget.phone,
                                              uid: uid,
                                            )));
                              });
                        } else {
                          showMyAlertDialog(context, 'Vui lòng nhập OTP');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btnColor,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      child: Text("Xác Nhận", style: btnTextStyle),
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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
