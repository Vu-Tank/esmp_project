import 'dart:async';

import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../providers/verify_provider.dart';
class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key, required this.phone}) : super(key: key);
  final String phone;
  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool _isResendOTP=true;
  String? _otpCode='';
  late Timer _timer;
  int _start=60;
  void reSend(){
    setState(() {
      _isResendOTP=true;
    });
    const oneSec= Duration(seconds: 1);
    _timer=new Timer.periodic(oneSec, (timer) {
      setState(() {
        if(_start==0){
          _start=60;
          _isResendOTP=false;
          timer.cancel();
        }else{
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
    final provider=Provider.of<VerifyProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8,right: 8),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: FlutterLogo(
                    size: 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("Xác Thực OTP", style: Theme.of(context).textTheme.headline6 ),
                ),
                Text('Số điện thoại ${widget.phone}',style: Theme.of(context).textTheme.headline6,),
                PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  appContext: context,
                  onChanged: (value){
                    print(value);
                  },
                  onCompleted: (value){
                    setState(() {
                      _otpCode = value;
                    });
                    print(value);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>[
                    const Text("Không nhận được OTP?", style: TextStyle(color: Colors.grey, fontSize: 16),),
                    TextButton(
                        onPressed: (){
                          if(_isResendOTP) return;
                          provider.verifyPhone(widget.phone, context);
                          reSend();
                        },
                        child: Text(_isResendOTP?"Thử lại sau "+ _start.toString()+" s" :"Gửi lại", style: TextStyle(color: Colors.blueAccent, fontSize: 16),) ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: provider.verifyPhoneStatus==Status.Authenticating
                    ? loading
                    : ElevatedButton(
                      onPressed: (){
                        provider.verifyOTP(_otpCode!,widget.phone, context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      child: const Text("Xác Nhận", style: TextStyle(
                          color: Colors.white,
                          fontSize: 15
                      )),
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
