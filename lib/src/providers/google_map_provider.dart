import 'package:esmp_project/src/models/address.dart';
import 'package:esmp_project/src/utils/widget/showSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../repositoty/google_repository.dart';
class GoogleMapProvider extends ChangeNotifier{
  bool isUpdate=false;
  GoogleAddress _address= GoogleAddress(
      formatted_address: "Long Thạnh Mỹ, Quận 9, Thành phố Hồ Chí Minh, Vietnam",
      lat: 10.8421949 ,
      lng:106.823737);

  GoogleAddress get address => _address;

  Future<void> goToMyLocation(BuildContext context) async {
    Position position = await GoogleMapService().getCurrent();
    if(position!=null){
      String? placeId = await GoogleMapService().getPlaceIdFromLoation(position.latitude, position.longitude);
      if(placeId !=null){
        _address= (await GoogleMapService().getPlace(placeId))!;
        notifyListeners();
      }else{
        showSnackBar(context, "Không thể định vị. Vui Lòng thử lại");
      }
    }else{
      showSnackBar(context, "Không thể định vị. Vui Lòng thử lại");
    }
  }
  Future<void> searchPlace(BuildContext context, String input) async{
    String? placeId= await GoogleMapService().getPlaceIdFromText(input);
    if(placeId !=null){
      _address= (await GoogleMapService().getPlace(placeId))!;
      notifyListeners();
    }else{
      showSnackBar(context, "Không thể định vị. Vui Lòng thử lại");
    }
  }
  void setLocationByMovingMap(GoogleAddress address) {
    _address = address;
    print('Vĩ độ: ${address.lat}');
    print('Kinh đô: ${address.lng}');
    notifyListeners();
  }
  Future<void> searchLocation(BuildContext context) async {
      String? placeId = await GoogleMapService().getPlaceIdFromLoation(address.lat, address.lng);
      if(placeId !=null){
        print('PlaceID: ${placeId}');
        _address= (await GoogleMapService().getPlace(placeId))!;
        notifyListeners();
      }else{
        showSnackBar(context, "Không thể định vị. Vui Lòng thử lại");
      }
  }
  void updateStatus(){
    isUpdate=true;
    notifyListeners();
  }
}