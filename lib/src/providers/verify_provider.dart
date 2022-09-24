import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/user_provider.dart';
import 'package:esmp_project/src/repositoty/user_repository.dart';
import 'package:esmp_project/src/utils/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/validation_item.dart';
import '../screens/otp_screen.dart';
import '../utils/widget/showSnackBar.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  NotVerify,
  Verified,
  Authenticating,
  Registering,
  LoggedOut
}

class VerifyProvider extends ChangeNotifier {
  ValidationItem _phone = ValidationItem(null, null);

  ValidationItem get phone => _phone;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = "";

  Status _loginPhoneStatus= Status.NotLoggedIn;
  Status get loginPhoneStatus=> _loginPhoneStatus;
  set loginPhoneStatus(Status value){
    _loginPhoneStatus=value;
  }

  Status _verifyPhoneStatus = Status.NotVerify;
  Status get verifyPhoneStatus => _verifyPhoneStatus;
  set verifyPhoneStatus(Status value) {
    _verifyPhoneStatus = value;
  }

  void validatePhoneNumber(String value) {
    String pattern = r'^(0|84|\+84){1}([3|5|7|8|9]){1}([0-9]{8})\b';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      _phone = ValidationItem(null, "Invalid phone number!");
    } else {
      if (value.indexOf('0') == 0) {
        value = value.replaceFirst("0", "+84");
      } else if (value.indexOf("8") == 0) {
        value = value.replaceFirst("8", "+8");
      }
      _phone = ValidationItem(value, null);
    }
    notifyListeners();
  }

  Future<void> verifyPhone(String phoneNumber, BuildContext context) async {
    _loginPhoneStatus = Status.Authenticating;
    notifyListeners();
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          _loginPhoneStatus = Status.Verified;
          notifyListeners();
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (error) {
          _loginPhoneStatus = Status.NotLoggedIn;
          notifyListeners();
          print("======================================================");
          print("Error: "+error.message!);
          print("======================================================");
        },
        codeSent: ((String verificationId, int? resendToken) async {
          _loginPhoneStatus = Status.Authenticating;
          notifyListeners();
          _verificationId = verificationId;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPScreen(phone: phoneNumber)));
        }),
        timeout: Duration(seconds: 20),
        codeAutoRetrievalTimeout: (String verificationId) {
          _loginPhoneStatus=Status.NotLoggedIn;
          notifyListeners();
        });
  }

  Future<void> verifyOTP(
      String otp, String phoneNumber, BuildContext context) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: otp);
    try {
      await _auth.signInWithCredential(credential);
      String token = await getIDToken();
      print("Token: "+token);
      verifyPhoneStatus = Status.Authenticating;
      notifyListeners();
      UserModel? user = await login(phoneNumber, token);
      if (user == null) {
        verifyPhoneStatus = Status.NotLoggedIn;
        notifyListeners();
        Navigator.pushReplacementNamed(context, '/login');
        showSnackBar(context, "Phone number not exist, Please create account!!!!");
      } else {
        verifyPhoneStatus = Status.Verified;
        notifyListeners();
        UserPreferences().saveUser(user);
        Provider.of<UserProvider>(context,listen: false).setUser(user);
        Navigator.pushReplacementNamed(context, "/home");
      }
    } catch (error) {
      verifyPhoneStatus = Status.NotVerify;
      notifyListeners();
      print(error.toString());
      if(error.toString().contains("firebase_auth/invalid-verification-code")){
        showSnackBar(context, "Invalid sms verification code");
      }else if(error.toString().contains("firebase_auth/session-expired")){
        print("error: "+error.toString());
        showSnackBar(context, "The sms code has expired. Please re-send the verification code to try again.");
      }
    }
  }

  Future<String> getIDToken() async {
    String token = await _auth.currentUser!.getIdToken(false);
    return token;
  }

}
