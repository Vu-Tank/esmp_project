import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/user_provider.dart';
import 'package:esmp_project/src/repositoty/user_repository.dart';
import 'package:esmp_project/src/utils/shared_preferences.dart';
import 'package:esmp_project/src/utils/utils.dart';
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

  Status loginPhoneStatus= Status.NotLoggedIn;
  Status verifyPhoneStatus= Status.NotVerify;

  void validatePhoneNumber(String value) {
    String pattern = r'^(0|84|\+84){1}([3|5|7|8|9]){1}([0-9]{8})\b';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      _phone = ValidationItem(null, "Invalid phone number!");
    } else {
      value=Utils.convertToFirebase(value);
      _phone = ValidationItem(value, null);
    }
    notifyListeners();
  }


  Future<void> verifyPhone({required String phoneNumber, required BuildContext context}) async {
    loginPhoneStatus = Status.Authenticating;
    notifyListeners();
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          loginPhoneStatus = Status.Verified;
          notifyListeners();
          await _auth.signInWithCredential(credential);
          String token = await getIDToken();
        },
        verificationFailed: (error) {
          loginPhoneStatus = Status.NotLoggedIn;
          notifyListeners();
          print("======================================================");
          print("Error: "+error.message!);
          print("======================================================");
        },
        codeSent: ((String verificationId, int? resendToken) async {
          loginPhoneStatus = Status.Authenticating;
          notifyListeners();
          _verificationId = verificationId;
          Navigator.push(context, MaterialPageRoute(builder: (context)=> OTPScreen(phone: phoneNumber)));
        }),
        timeout: Duration(seconds: 20),
        codeAutoRetrievalTimeout: (String verificationId) {
          loginPhoneStatus=Status.NotLoggedIn;
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
      // print(token);
      verifyPhoneStatus = Status.Authenticating;
      notifyListeners();
      ApiResponse apiResponse = await login(phoneNumber, token);
      if (!apiResponse.isSuccess!) {
        verifyPhoneStatus = Status.NotLoggedIn;
        notifyListeners();
        // Navigator.pushReplacementNamed(context, '/login');
        showSnackBar(context, apiResponse.message!);

      } else {
        verifyPhoneStatus = Status.Verified;
        notifyListeners();
        print((apiResponse.dataResponse as UserModel).userName);
        // UserPreferences().saveUser(user);
        // Provider.of<UserProvider>(context,listen: false).setUser(user);
        // Navigator.pushReplacementNamed(context, "/home");
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
