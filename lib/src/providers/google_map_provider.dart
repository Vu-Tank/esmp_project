import 'package:esmp_project/src/models/address.dart';
import 'package:esmp_project/src/models/validation_item.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../repositoty/google_repository.dart';
class GoogleMapProvider extends ChangeNotifier{
  bool isUpdate=false;
  GoogleAddress _address= GoogleAddress(
      formattedAddress: "Long Thạnh Mỹ, Quận 9, Thành phố Hồ Chí Minh, Vietnam",
      lat: 10.8421949 ,
      lng:106.823737);

  GoogleAddress get address => _address;

  late AddressModel addressModel;


  Future<void> goToMyLocation(Function onFiled) async {
    Position? position = await GoogleMapService().getCurrent();
    if(position!=null){
      String? placeId = await GoogleMapService().getPlaceIdFromLoation(position.latitude, position.longitude);
      if(placeId !=null){
        _address= (await GoogleMapService().getPlace(placeId))!;
        notifyListeners();
      }else{
        onFiled('Không thể định vị. Vui Lòng thử lại');
      }
    }else{
      onFiled('Không thể định vị. Vui Lòng thử lại');
    }
  }
  Future<void> searchPlace(Function onFiled, String input) async{
    String? placeId= await GoogleMapService().getPlaceIdFromText(input);
    if(placeId !=null){
      _address= (await GoogleMapService().getPlace(placeId))!;
      notifyListeners();
    }else{
      onFiled('Không thể định vị. Vui Lòng thử lại');
    }
  }
  void setLocationByMovingMap(GoogleAddress address) {
    _address = address;
    // print('Vĩ độ: ${address.lat}');
    // print('Kinh đô: ${address.lng}');
    notifyListeners();
  }
  ValidationItem _mapStatus= ValidationItem(null, null);

  ValidationItem get mapStatus => _mapStatus;

  void checkSelectMap(){
    if(isUpdate){
      _mapStatus= ValidationItem(null, null);
    }else{
      _mapStatus=ValidationItem(null, "Vui Lòng chọn địa chỉ");
    }
    notifyListeners();
  }
  Future<void> searchLocation(Function onFailed) async {
      String? placeId = await GoogleMapService().getPlaceIdFromLoation(address.lat, address.lng);
      if(placeId !=null){
        _address= (await GoogleMapService().getPlace(placeId))!;
        notifyListeners();
      }else{
        onFailed('Không thể định vị. Vui Lòng thử lại');
      }
  }
  void updateStatus(){
    isUpdate=true;
    addressModel=getAddress()!;
    notifyListeners();
  }

  AddressModel? getAddress() {
    AddressModel addressModel= AddressModel();
    if(_address.formattedAddress.split(',').length>=3) {
      addressModel.province=_address.formattedAddress.split(',')[_address.formattedAddress.split(',').length-1];
      addressModel.district=_address.formattedAddress.split(',')[_address.formattedAddress.split(',').length-2];
      addressModel.ward=_address.formattedAddress.split(',')[_address.formattedAddress.split(',').length-3];
      addressModel.latitude=_address.lat;
      addressModel.longitude=_address.lng;
      addressModel.context="";
      return addressModel;
    }
    return null;
  }
}