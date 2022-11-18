import 'dart:developer';

import 'package:esmp_project/src/models/address.dart';
import 'package:esmp_project/src/models/validation_item.dart';
import 'package:esmp_project/src/utils/validations.dart';
import 'package:flutter/material.dart';

class AddressProvider extends ChangeNotifier{
  AddressModel? addressModel;
  void setAddress(AddressModel? address){
    addressModel=address;
    resetProvider();
    // notifyListeners();
  }
  void resetProvider(){
    _validContext=ValidationItem(null, null);
    _validUserPhone=ValidationItem(null, null);
    _validUserName=ValidationItem(null, null);
    _validLocation=ValidationItem(null, null);
  }


  ValidationItem _validUserName= ValidationItem(null, null);
  ValidationItem get validUserName => _validUserName;
  bool validName(String? value){
    _validUserName=Validations.validUserName(value);
    notifyListeners();
    if(_validUserName.value!=null){
      addressModel?.userName=value;
      return true;
    }
    return false;
  }

  ValidationItem _validUserPhone=ValidationItem(null, null);
  ValidationItem get validUserPhone => _validUserPhone;
  bool validPhone(String? value){
    _validUserPhone=Validations.valPhoneNumber(value);
    notifyListeners();
    if(_validUserPhone.value!=null){
      addressModel?.userPhone=value;
      return true;
    }
    return false;
  }
  ValidationItem _validContext=ValidationItem(null, null);

  ValidationItem get validContext => _validContext;
  bool validContex(String? value){
    _validContext=Validations.valAddressContex(value);
    notifyListeners();
    if(_validContext.value!=null){
      addressModel?.context=value;
      return true;
    }
    return false;
  }
  void setNewAddress(AddressModel address){
    addressModel ??= AddressModel();
    addressModel!.longitude=address.longitude;
    addressModel!.latitude=address.latitude;
    addressModel!.province=address.province;
    addressModel!.district=address.district;
    addressModel!.ward=address.ward;
    _validLocation=ValidationItem(null, null);
    notifyListeners();
  }

  ValidationItem _validLocation=ValidationItem(null, null);

  ValidationItem get validLocation => _validLocation;
  bool isValidLocation(){
    if(addressModel?.longitude!=null&& addressModel?.latitude!=null&&addressModel?.ward!=null&& addressModel?.district!=null&& addressModel?.province!=null){
      _validLocation=ValidationItem(null, null);
      notifyListeners();
      return true;
    }
    _validLocation=ValidationItem(null, "Vui Lòng chọn vị trí trên Bản đồ");
    notifyListeners();
    return false;
  }
}