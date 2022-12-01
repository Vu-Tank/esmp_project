
import 'package:esmp_project/src/models/address.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/validation_item.dart';
import 'package:esmp_project/src/repositoty/address_repository.dart';
import 'package:esmp_project/src/repositoty/google_repository.dart';
import 'package:esmp_project/src/repositoty/user_repository.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/validations.dart';
import 'package:flutter/material.dart';

class AddressProvider extends ChangeNotifier {
  AddressModel? addressModel;

  void setAddress(AddressModel? address) {
    addressModel = address;
    resetProvider();
    // notifyListeners();
  }

  void resetProvider() {
    _validUserPhone = ValidationItem(null, null);
    _validUserName = ValidationItem(null, null);
    _addressValid = ValidationItem(null, null);
    _listProvince.clear();
    selectedProvince = null;
    selectedDistrict = null;
    selectedWard = null;
  }

  List<Province> _listProvince = [];

  List<Province> get listProvince => _listProvince;
  Province? selectedProvince;

  Future<void> initProvince() async {
    List<Province> listP = await AddressRepository.getProvince();
    _listProvince.addAll(listP);
    if (addressModel != null) {
      selectedProvince =
          Utils.searchProvince(_listProvince, addressModel!.province!);
      selectedDistrict = Utils.searchDistrict(
          selectedProvince!.listDistrict, addressModel!.district!);
      selectedWard =
          Utils.searchWard(selectedDistrict!.listWard, addressModel!.ward!);
      // log(selectedWard.toString());
    } else {
      selectedProvince = _listProvince.first;
    }
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

  ValidationItem _addressValid = ValidationItem(null, null);

  ValidationItem get addressValid => _addressValid;

  Future<bool> validAddress(String? value) async{
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
    addressModel ??= AddressModel();
    addressModel!.context = value;
    addressModel!.province= selectedProvince!.name_with_type;
    addressModel!.district=selectedDistrict!.name_with_type;
    addressModel!.ward=selectedWard!.name_with_type;
    String? placeId= await GoogleMapService().getPlaceIdFromText('${addressModel!.context}, ${addressModel!.ward}, ${addressModel!.district}, ${addressModel!.province}');
    if(placeId==null){
      _addressValid =
          ValidationItem(null, "Lỗi, thử lại sau");
      notifyListeners();
      return false;
    }
    GoogleAddress? googleAddress=await GoogleMapService().getPlace(placeId);
    if(googleAddress==null){
      _addressValid =
          ValidationItem(null, "Lỗi, thử lại sau");
      notifyListeners();
      return false;
    }
    addressModel!.longitude=googleAddress.lng;
    addressModel!.latitude=googleAddress.lat;
    _addressValid = ValidationItem(null, null);
    notifyListeners();
    return true;
  }

  ValidationItem _validUserName = ValidationItem(null, null);

  ValidationItem get validUserName => _validUserName;

  bool validName(String? value) {
    _validUserName = Validations.validUserName(value);
    notifyListeners();
    if (_validUserName.value != null) {
      addressModel?.userName = value;
      return true;
    }
    return false;
  }

  ValidationItem _validUserPhone = ValidationItem(null, null);

  ValidationItem get validUserPhone => _validUserPhone;

  bool validPhone(String? value) {
    _validUserPhone = Validations.valPhoneNumber(value);
    notifyListeners();
    if (_validUserPhone.value != null) {
      addressModel?.userPhone = Utils.convertToDB(value!);
      return true;
    }
    return false;
  }

  void setNewAddress(AddressModel address) {
    addressModel ??= AddressModel();
    addressModel!.longitude = address.longitude;
    addressModel!.latitude = address.latitude;
    addressModel!.province = address.province;
    addressModel!.district = address.district;
    addressModel!.ward = address.ward;
    notifyListeners();
  }

  Future<void> createAddress(
      {required int userID,
      required String token,
      required Function onSuccess,
      required Function onFailed}) async {
    ApiResponse apiResponse = await UserRepository.createAddress(
        addressModel: addressModel!, userID: userID, token: token);
    if(apiResponse.isSuccess!){
      onSuccess(apiResponse.dataResponse as List<AddressModel>);
      resetProvider();
    }else{
      onFailed(apiResponse.message);
    }
  }
  Future<void> updateAddress(
      {required String token,
        required Function onSuccess,
        required Function onFailed}) async {
    ApiResponse apiResponse = await UserRepository.updateAddress(
        addressModel: addressModel!, token: token);
    if(apiResponse.isSuccess!){
      onSuccess(apiResponse.dataResponse as AddressModel);
      resetProvider();
    }else{
      onFailed(apiResponse.message);
    }
  }
}
