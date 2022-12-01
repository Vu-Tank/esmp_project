import 'dart:developer';

import 'package:esmp_project/src/constants/url.dart';
import 'package:esmp_project/src/models/address.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/imageModel.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/models/validation_item.dart';
import 'package:esmp_project/src/repositoty/address_repository.dart';
import 'package:esmp_project/src/repositoty/cloud_firestore_service.dart';
import 'package:esmp_project/src/repositoty/google_repository.dart';
import 'package:esmp_project/src/repositoty/user_repository.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/validations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterProvider extends ChangeNotifier {
  static final List<String> _genders = <String>[
    'Khác',
    'Nam',
    'Nữ',
  ];
  static final ImageModel _image =
      ImageModel(path: AppUrl.defaultAvatar, fileName: 'defaultAvatar.png');
  UserModel _user =
      UserModel(gender: _genders.first, address: [], image: _image);

  List<String> get genders => _genders;

  UserModel get user => _user;

  void setPhoneNumber(String phone) {
    _user.phone = Utils.convertToDB(phone);
  }

  List<Province> _listProvince = [];

  List<Province> get listProvince => _listProvince;
  Province? selectedProvince;

  Future<void> initProvince() async {
    List<Province> listP = await AddressRepository.getProvince();
    _listProvince.addAll(listP);
    selectedProvince = _listProvince.first;
    notifyListeners();
  }

  District? selectedDistrict;
  Ward? selectedWard;

  void onChangeProvince(Province? value) {
    if (value != null) {
      selectedProvince = value;
      if (value.code == '-1') {
        selectedDistrict = null;
        selectedWard = null;
      } else {
        selectedDistrict = value.listDistrict.first;
        selectedWard = null;
      }
      notifyListeners();
    }
  }

  void onChangeDistrict(District? value) {
    if (value != null) {
      selectedDistrict = value;
      if (value.code == '-1') {
        selectedWard = null;
      } else {
        selectedWard = value.listWard.first;
      }
      notifyListeners();
    }
  }

  void onChangeWard(Ward? value) {
    if (value != null) {
      selectedWard = value;
      notifyListeners();
    }
  }

  ValidationItem _fullName = ValidationItem(null, null);

  ValidationItem get fullName => _fullName;

  bool validFullName(String? value) {
    _fullName = Validations.validUserName(value);
    notifyListeners();
    if (_fullName.value != null) {
      return true;
    }
    return false;
  }

  AddressModel? _address;

  AddressModel? get address => _address;
  ValidationItem _addressValid = ValidationItem(null, null);

  ValidationItem get addressValid => _addressValid;

  bool validAddress(String? value) {
    if (selectedProvince == null || selectedProvince!.code == '-1') {
      _addressValid = ValidationItem(null, "Vui lòng chọn tính/ thành phố");
      notifyListeners();
      return false;
    }
    if (selectedDistrict == null || selectedDistrict!.code == '-1') {
      _addressValid = ValidationItem(null, "Vui lòng chọn quận/ huyện");
      notifyListeners();
      return false;
    }
    if (selectedWard == null || selectedWard!.code == '-1') {
      _addressValid = ValidationItem(null, "Vui lòng chọn phường/ xã");
      notifyListeners();
      return false;
    }
    if (value == null || value.isEmpty) {
      _addressValid =
          ValidationItem(null, "Vui lòng nhập Số nhà, tên đường (thôn, xóm)");
      notifyListeners();
      return false;
    }
    _addressValid = ValidationItem(null, null);
    notifyListeners();
    return true;
  }

  void genderOnchange(String? value) {
    _user.gender = value;
    notifyListeners();
  }

  ValidationItem _email = ValidationItem(null, null);

  ValidationItem get email => _email;

  bool validEmail(String? value) {
    _email = Validations.valEmail(value);
    notifyListeners();
    if (_email.value != null) {
      return true;
    } else {
      return false;
    }
  }

  ValidationItem _dob = ValidationItem(null, null);

  ValidationItem get dob => _dob;

  void checkDOB() {
    if (user.dateOfBirth == null) {
      _dob = ValidationItem(null, "Vui Lòng chọn ngày sinh");
    } else {
      _dob = ValidationItem(user.dateOfBirth, null);
    }
    notifyListeners();
  }

  bool selectDOB(DateTime? value) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String dob = dateFormat.format(value!);
    user.dateOfBirth = dob;
    _dob = ValidationItem(dob, null);
    notifyListeners();
    return true;
  }

  Future<bool> registerUser(String token, String? uid, String addressString,
      Function onSuccess, Function onFailed) async {
    _user.token = token;
    _user.userName = _fullName.value;
    _user.email = _email.value;
    _user.firebaseID = uid;
    _user.fcM_Firebase = await FirebaseMessaging.instance.getToken();
    GoogleAddress? address = await getLatLng(
        addressString,
        selectedWard!.name_with_type,
        selectedDistrict!.name_with_type,
        selectedProvince!.name_with_type);
    if (address == null) {
      onFailed('Lỗi không lấy được vị trí vui lòng thử lại sau');
      return false;
    }
    log("message: $addressString");
    AddressModel myAddress=AddressModel(
      context: addressString,
      province: selectedProvince!.name_with_type,
      district: selectedDistrict!.name_with_type,
      ward: selectedWard!.name_with_type,
      longitude: address.lng,
      latitude: address.lat,
    );
    log(myAddress.toString());
    _user.address=[myAddress];
    log("contex: ${_user.address![0].toString()}");
    ApiResponse apiResponse = await UserRepository.createUser(_user);
    log(apiResponse.message!);
    if (apiResponse.isSuccess!) {
      await CloudFirestoreService(uid: uid).createUserCloud(
          userName: _user.userName!, imageUrl: _user.image!.path!);
      onSuccess();
    } else {
      onFailed(apiResponse.message);
    }
    return false;
  }

  Future getLatLng(
      String context, String ward, String district, String province) async {
    GoogleAddress? address;
    String? placeID = await GoogleMapService()
        .getPlaceIdFromText('$context, $ward, $district, $province');
    if (placeID != null) {
      address = await GoogleMapService().getPlace(placeID);
    }
    return address;
  }

  void reset() {
    _user = UserModel(gender: _genders.first, address: [], image: _image);
    _fullName = ValidationItem(null, null);
    _addressValid = ValidationItem(null, null);
    _address = null;
    _email = ValidationItem(null, null);
    _dob = ValidationItem(null, null);
    _listProvince.clear();
    selectedProvince=null;
    selectedWard=null;
    selectedDistrict=null;
  }
}
