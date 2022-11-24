import 'dart:developer';

import 'package:esmp_project/src/models/imageModel.dart';
import 'package:esmp_project/src/models/role.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/repositoty/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/api_response.dart';

class UserPreferences {
  Future<bool> saveUser(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("userID", user.userID!);
    prefs.setString("token", user.token!);

    return prefs.commit();
  }

  Future<UserModel?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("userID");
    if(userId==null){
      return null;
    }
    String? token = prefs.getString("token");
    ApiResponse apiResponse = await UserRepository.reFeshToken(userId: userId, token: token!);
    // final fcmToken = await FirebaseMessaging.instance.getToken();
    // log(fcmToken.toString());
    // log(apiResponse.message!);
    if(apiResponse.isSuccess!){
      log("getUser: ${apiResponse.message}");
      return apiResponse.dataResponse as UserModel;
    }else{
      log("error getUser: ${apiResponse.message}");
      removeUser();
      return null;
    }
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userID");
    prefs.remove("token");
    await FirebaseAuth.instance.signOut();
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    return token!;
  }
}
