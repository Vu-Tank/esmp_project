import 'package:esmp_project/src/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  UserModel _user= UserModel();
  UserModel get user => _user;
  void setUser(UserModel user){
    _user=user;
    notifyListeners();
  }
}