// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/repositoty/user_repository.dart';
import 'package:esmp_project/src/utils/shared_preferences.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/validations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/validation_item.dart';
import '../screens/login_register/otp_screen.dart';


class VerifyProvider extends ChangeNotifier {
  ValidationItem _phone = ValidationItem(null, null);

  ValidationItem get phone => _phone;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = "";



  bool validPhoneNumber(String? value){
    _phone=Validations.valPhoneNumber(value);
    notifyListeners();
    if(_phone.value!=null){
      return true;
    }
    return false;
  }

  Future<void> verifyPhone({
    required String phoneNumber,
    required BuildContext context,
    required String status,
    required Function onFailed,
    required Function onLogin,
    required Function onRegister,
  }) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          String token = await getIDToken();
          try {
            String phone= Utils.convertToDB(phoneNumber);
            ApiResponse apiResponse =
                await UserRepository.login(phone, token);
            if (!apiResponse.isSuccess!) {
              onFailed(apiResponse.message!);
            } else {
              if (status == 'login') {
                UserModel user = apiResponse.dataResponse as UserModel;
                UserPreferences().saveUser(user);
                onLogin(user);
              } else if (status == 'register') {
                onRegister(token);
              }
            }
          } catch (error) {
            onFailed(error.toString());
          }
        },
        verificationFailed: (error) {
          onFailed(error.message);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          _verificationId = verificationId;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPScreen(
                        phone: phoneNumber,
                        status: status,
                      )));
        }),
        timeout: const Duration(seconds: 10),
        codeAutoRetrievalTimeout: (String verificationId) {
        }
        );
  }

  Future<void> verifyOTP({
    required String otp,
    required String phoneNumber,
    required String status,
    required Function onFailed,
    required Function onLogin,
    required Function onRegister,
  }) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: otp);
    try {
      await _auth.signInWithCredential(credential);
      String token = await getIDToken();
      // log('token: $token');
      String phone= Utils.convertToDB(phoneNumber);
      if (status == 'login') {
        ApiResponse apiResponse =
            await UserRepository.login(phone, token);
        if (!apiResponse.isSuccess!) {
          onFailed(apiResponse.message);
        } else {
          UserModel user = apiResponse.dataResponse as UserModel;
          UserPreferences().saveUser(user);
          onLogin(user);
        }
      } else if (status == 'register') {
        onRegister(token);
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
}
