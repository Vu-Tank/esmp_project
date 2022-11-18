import 'dart:developer';

import 'package:esmp_project/src/constants/url.dart';
import 'package:esmp_project/src/models/address.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/imageModel.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/models/validation_item.dart';
import 'package:esmp_project/src/repositoty/user_repository.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/validations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterProvider extends ChangeNotifier {

  static final List<String> _genders = <String>['Khác','Nam', 'Nữ',];
  static final ImageModel _image= ImageModel(path: AppUrl.defaultAvatar,fileName: 'defaultAvatar.png');
  UserModel _user = UserModel(gender: _genders.first,address: [], image: _image);

  List<String> get genders => _genders;

  UserModel get user => _user;
  void setPhoneNumber(String phone){
    _user.phone=Utils.convertToDB(phone);
  }

  ValidationItem _fullName= ValidationItem(null, null);
  ValidationItem get fullName => _fullName;
  bool validFullName(String? value) {
    _fullName=Validations.validUserName(value);
    notifyListeners();
    if(_fullName.value!=null){
      return true;
    }
    return false;
  }
  AddressModel? _address;

  AddressModel? get address => _address;
  ValidationItem _addressMapValid= ValidationItem(null, null);

  ValidationItem get addressMapValid => _addressMapValid;
  ValidationItem _addressValid= ValidationItem(null, null);
  ValidationItem get addressValid => _addressValid;
  bool validAddress(String? value){
    if(_address!=null){
      _addressValid=Validations.valAddressContex(value);
      notifyListeners();
      if(_addressValid.value!=null){
        return true;
      }
    }else{
      _addressMapValid= ValidationItem(null, "Vui Lòng chọn địa chỉ");
      notifyListeners();
    }
    return false;

  }
  void genderOnchange(String? value){
    _user.gender= value;
    notifyListeners();
  }
  ValidationItem _email = ValidationItem(null, null);
  ValidationItem get email => _email;
  bool validEmail(String? value){
    _email=Validations.valEmail(value);
    notifyListeners();
    if(_email.value!=null){
      return true;
    }else{
      return false;
    }
  }
  ValidationItem _dob= ValidationItem(null, null);
  ValidationItem get dob => _dob;
  void checkDOB(){
    if(user.dateOfBirth==null){
      _dob= ValidationItem(null, "Vui Lòng chọn ngày sinh");
    }else{
      _dob= ValidationItem(user.dateOfBirth, null);
    }
    notifyListeners();
  }
  bool selectDOB(DateTime? value){
    DateFormat dateFormat= DateFormat("yyyy-MM-dd");
    String dob= dateFormat.format(value!);
    user.dateOfBirth=dob;
    _dob= ValidationItem(dob, null);
    notifyListeners();
    return true;
  }
  // void setImage(String urlImage, String imageName){
  //   _user.image?.fileName=imageName;
  //   _user.image?.path=urlImage;
  // }
  void setAddressFromMap(AddressModel addressModel){
    if(_user.address!.isEmpty){
      _user.address!.add(addressModel);
    }else{
      _user.address?[0]=addressModel;
    }
    _address=addressModel;
    _addressMapValid=ValidationItem(null, null);
    notifyListeners();
  }
  Future<bool> registerUser(String token, Function onSuccess, Function onFailed)async{
    _user.token=token;
    _user.userName=_fullName.value;
    _user.email=_email.value;
    _user.address![0].context=_addressValid.value;
    ApiResponse apiResponse=await UserRepository.createUser(_user);
    log(apiResponse.message!);
    if(apiResponse.isSuccess!){
      _user=UserModel(gender: _genders.first,address: [_address!], image: _image);
      onSuccess();
    }else{
      onFailed(apiResponse.message);
    }
    return false;
  }
  void reset(){
    _user = UserModel(gender: _genders.first,address: [], image: _image);
    _fullName= ValidationItem(null, null);
    _addressMapValid= ValidationItem(null, null);
    _addressValid= ValidationItem(null, null);
    _address=null;
    _email = ValidationItem(null, null);
    _dob= ValidationItem(null, null);
  }
}
