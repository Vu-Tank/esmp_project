import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/validation_item.dart';
import '../screens/otp_screen.dart';
import '../widget/showSnackBar.dart';

class VerifyProvider extends ChangeNotifier{
  ValidationItem _phone = new ValidationItem(null, null);

  ValidationItem get phone => _phone;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId="";
  void validatePhoneNumber(String value) {
    String pattern = r'^(0|84|\+84){1}([3|5|7|8|9]){1}([0-9]{8})\b';
    RegExp regExp = new RegExp(pattern);
    print("phone value: "+value);
    if (!regExp.hasMatch(value)) {
      _phone = ValidationItem(null, "Số điện thoại không đúng!");
    } else {
      if (value.indexOf('0') == 0) {
        value=value.replaceFirst("0","+84");
      }else if(value.indexOf("8")==0){
        value=value.replaceFirst("8","+8");
      }
      _phone = ValidationItem(value, null);
    }
    notifyListeners();
  }
  Future<void> verifyPhone(String phoneNumber, BuildContext context) async {
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async{
            await _auth.signInWithCredential(credential);
          },
          verificationFailed: (error){
            showSnackBar(context, error.message!);
          },
          codeSent: ((String verificationId, int? resendToken) async{
            _verificationId=verificationId;
            Navigator.push(context, MaterialPageRoute(builder: (context)=>OTPScreen(phone: phoneNumber)));
          }),
          timeout: const Duration(seconds: 60),
          codeAutoRetrievalTimeout: (String verificationId){
            showSnackBar(context, "Time Out!! Resend OTP!!!");
          });
  }
  Future<void> verifyOTP(String otp, BuildContext context) async{
    PhoneAuthCredential credential= PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp
    );
    try{
      await _auth.signInWithCredential(credential);
      String token= await getIDToken();
      log(token);
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, "/home");
    }catch(e){
      showSnackBar(context, e.toString(),);
    }
  }
  Future<String> getIDToken() async {
    String token = await _auth.currentUser!.getIdToken(false);
    return token;
  }
}