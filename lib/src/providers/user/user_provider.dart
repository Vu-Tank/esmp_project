import 'package:esmp_project/src/models/address.dart';
import 'package:esmp_project/src/models/imageModel.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/utils/shared_preferences.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  UserModel? _user;
  UserModel? get user => _user;
  void setUser(UserModel user){
    UserPreferences().saveUser(user);
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
  void setAddress(AddressModel addressModel){
    for(int i=0;i<_user!.address!.length;i++){
      if(_user!.address![i].addressID==addressModel.addressID){
        _user!.address![i]=addressModel;
        notifyListeners();
        return;
      }
    }
  }
  void setListAddress(List<AddressModel> list){
    _user!.address=list;
    notifyListeners();
  }
  void deleteAddress(int addressID){
    for(int i=0;i<_user!.address!.length;i++){
      if(_user!.address![i].addressID==addressID){
        _user!.address!.removeAt(i);
        notifyListeners();
        return;
      }
    }
  }
}