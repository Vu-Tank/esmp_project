import 'dart:developer';

import 'package:esmp_project/src/models/address.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../repositoty/google_repository.dart';

class MapProvider extends ChangeNotifier{
  final GoogleAddress _default= GoogleAddress(
      formattedAddress: "Long Thạnh Mỹ, Quận 9, Thành phố Hồ Chí Minh",
      lat: 10.8421949 ,
      lng:106.823737);
  GoogleAddress _address= GoogleAddress(
      formattedAddress: "Long Thạnh Mỹ, Quận 9, Thành phố Hồ Chí Minh",
      lat: 10.8421949 ,
      lng:106.823737);

  GoogleAddress get address => _address;

  void initData(AddressModel? addressModel){
    if(addressModel!=null){
      _address.formattedAddress='${addressModel.ward}, ${addressModel.district}, ${addressModel.province}';
      _address.lat=addressModel.latitude!;
      _address.lng=addressModel.longitude!;
    }else{
      _address=_default;
    }
    // log(addressModel!.toString());
  }
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