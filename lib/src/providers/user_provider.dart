import 'package:esmp_project/src/models/imageModel.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  UserModel? _user;
  UserModel? get user => _user;
  void setUser(UserModel user){
    _user=user;
    notifyListeners();
  }
  void logOut(){
    _user=null;
    notifyListeners();
  }
  void setUserImage(ImageModel image){
    _user!.image=image;
    notifyListeners();
  }
}