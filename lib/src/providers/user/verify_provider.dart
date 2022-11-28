// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:developer';

import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/repositoty/user_repository.dart';
import 'package:esmp_project/src/utils/shared_preferences.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/validations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../models/validation_item.dart';

class VerifyProvider extends ChangeNotifier {
  ValidationItem _phone = ValidationItem(null, null);
  String _otp='';

  String get otp => _otp;

  ValidationItem get phone => _phone;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool validPhoneNumber(String? value) {
    _phone = Validations.valPhoneNumber(value);
    notifyListeners();
    if (_phone.value != null) {
      return true;
    }
    return false;
  }

  Future<void> verifyPhone({
    required String phoneNumber,
    required String status,
    required Function onFailed,
    required Function onSendCode,
    Function? onLogin,
    Function? onRegister,
  }) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          if(credential.smsCode!=null&&credential.verificationId!=null){
            _otp=credential.smsCode!;
            // Timer(const Duration(seconds: 3), () {
            //   verifyOTP(otp: otp, phoneNumber: phoneNumber, verificationId: credential.verificationId!, status: status, onFailed: onFailed);
            // });
          }
          // final user=await _auth.signInWithCredential(credential);
          // String token = await getIDToken();
          // try {
          //   if(status=='login'){
          //     String phone = Utils.convertToDB(phoneNumber);
          //     final fcmToken = await FirebaseMessaging.instance.getToken();
          //     ApiResponse apiResponse = await UserRepository.login(phone, token, fcmToken);
          //     if (!apiResponse.isSuccess!) {
          //       onFailed(apiResponse.message!);
          //     } else {
          //       UserModel user = apiResponse.dataResponse as UserModel;
          //       UserPreferences().saveUser(user);
          //       onLogin!(user);
          //     }
          //   }else if(status=='register'){
          //     onRegister!(token, user.user?.uid);
          //   }
          // } catch (error) {
          //   onFailed(error.toString());
          // }
        },
        verificationFailed: (error) {
          log("error code: ${error.code}");
          log("error message: ${error.message}");
          String? err;
          if(error.code=='too-many-requests'){
            err='Chúng tôi đã chặn tất cả các yêu cầu từ thiết bị này do hoạt động bất thường. Thử lại sau.';
          }else{
            err=error.message;
          }
          onFailed(err);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          onSendCode(verificationId);
        }),
        // timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  Future<void> verifyOTP({
    required String otp,
    required String phoneNumber,
    required String verificationId,
    required String status,
    required Function onFailed,
    Function? onLogin,
    Function? onRegister,
  }) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    try {
      final user=await _auth.signInWithCredential(credential);
      String token = await getIDToken();
      String phone = Utils.convertToDB(phoneNumber);
      if (status == 'login') {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        log(token);
        ApiResponse apiResponse = await UserRepository.login(phone, token, fcmToken);
        if (!apiResponse.isSuccess!) {
          onFailed(apiResponse.message);
        } else {
          UserModel user = apiResponse.dataResponse as UserModel;
          UserPreferences().saveUser(user);
          onLogin!(user);
        }
      } else if (status == 'register') {
        onRegister!(token, user.user?.uid);
      }
    } catch (error) {
      if (error
          .toString()
          .contains("firebase_auth/invalid-verification-code")) {
        onFailed('Mã xác minh OTP không hợp lệ');
      } else if (error.toString().contains("firebase_auth/session-expired")) {
        onFailed('Mã sms đã hết hạn. Vui lòng gửi lại mã xác minh để thử lại.');
      }
    }
  }

  Future<String> getIDToken() async {
    String token = await _auth.currentUser!.getIdToken(false);
    return token;
  }

  Future<void> login({required String phone,
    required Function onSendCode,
    required Function onSuccess,
    required Function onFailed}) async {
    phone = Utils.convertToFirebase(phone);
    phone = Utils.convertToDB(phone);
    ApiResponse apiResponse =
    await UserRepository.checkExistUserWithPhone(phone);
    if (apiResponse.isSuccess!) {
      phone = Utils.convertToFirebase(phone);
      await verifyPhone(
          phoneNumber: phone,
          status: 'login',
          onFailed: onFailed,
          onLogin: onSuccess,
          onSendCode: onSendCode);
    } else {
      onFailed(apiResponse.message!);
    }
  }

  Future<void> register(
      {required String phone, required Function onFailed, required Function onSendCode, required Function onSuccess }) async {
    phone = Utils.convertToFirebase(phone);
    phone = Utils.convertToDB(phone);
    ApiResponse apiResponse =
    await UserRepository.checkExistUserWithPhone(phone);
    if (!apiResponse.isSuccess!) {
      phone = Utils.convertToFirebase(phone);
      await verifyPhone(phoneNumber: phone,
          status: 'register',
          onFailed: onFailed,
          onSendCode: onSendCode,
          onRegister: onSuccess
      );
    }else{
      onFailed(apiResponse.message!);
    }
  }
}
