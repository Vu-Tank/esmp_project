import 'package:esmp_project/src/models/address.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
class GoogleMapService{
  final String key="AIzaSyADjxEnevkvdc4WeRfYdt1w6KCZXNkZUZA";
  final String _key="JPqKdDZwdTYCSC4lYyqGyYgCmQk7nTtqnp7galEn";
  //google
  // Future<String?> getPlaceIdFromText(String input) async{
  //   String? placeID;
  //   String url='https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&language=vi&region=VN&key=$key';
  //   var response = await http.get(Uri.parse(url));
  //   if(response.statusCode==200){
  //     var json= convert.jsonDecode(response.body);
  //     if(json['status'].toString()=="OK") {
  //       placeID=json['candidates'][0]['place_id'] as String;
  //     }
  //   }
  //   return placeID;
  // }
  //goong
  Future<String?> getPlaceIdFromText(String input) async{
    String? placeID;
    String url='https://rsapi.goong.io/Place/AutoComplete?api_key=$_key&input=$input&radius=50';
    var response = await http.get(Uri.parse(url));
    if(response.statusCode==200){
      var json= convert.jsonDecode(response.body);
      if(json['status'].toString()=="OK") {
        placeID=json['predictions'][0]['place_id'] as String;
      }
    }
    return placeID;
  }
  //google
  // Future<String?> getPlaceIdFromLoation(double lat, double lng) async{
  //   String? placeID;
  //   String url='https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
  //       +'location=$lat%2C$lng'
  //       +'&radius=10&language=vi&region=VN&'
  //       +'key=$key';
  //   var response = await http.get(Uri.parse(url));
  //   if(response.statusCode==200){
  //
  //     var json= convert.jsonDecode(response.body);
  //     if(json['status'].toString()=="OK") {
  //         var jsons=json['results'] as List;
  //         if(jsons.length>1) {
  //           placeID=json['results'][1]['place_id'];
  //         } else {
  //           placeID=json['results'][0]['place_id'];
  //         }
  //     }
  //   }
  //   return placeID;
  // }
  //goong
  Future<String?> getPlaceIdFromLoation(double lat, double lng) async{
    String? placeID;
    String url='https://rsapi.goong.io/Geocode?latlng=$lat,%20$lng&api_key=$_key';
    var response = await http.get(Uri.parse(url));
    if(response.statusCode==200){
      var json= convert.jsonDecode(response.body);
      if(json['status'].toString()=="OK") {
        var jsons=json['results'] as List;
        // if(jsons.length>1) {
        //   placeID=json['results'][1]['place_id'];
        // } else {
        //   placeID=json['results'][0]['place_id'];
        // }
        placeID=jsons[0]['place_id'];
      }
    }
    return placeID;
  }
  //google
  // Future<GoogleAddress?> getPlace(String placeId) async{
  //   GoogleAddress? result;
  //   final String url='https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
  //   var response = await http.get(Uri.parse(url));
  //   if(response.statusCode==200){
  //     var json= convert.jsonDecode(response.body);
  //     if(json['status']=='OK'){
  //       result=GoogleAddress.fromJson(json['result']);
  //     }
  //   }
  //   return result;
  // }
  //goong
  Future<GoogleAddress?> getPlace(String placeId) async{
    GoogleAddress? result;
    final String url='https://rsapi.goong.io/Place/Detail?place_id=$placeId&api_key=$_key';
    var response = await http.get(Uri.parse(url));
    if(response.statusCode==200){
      var json= convert.jsonDecode(response.body);
      if(json['status']=='OK'){
        result=GoogleAddress.fromJson(json['result']);
      }
    }
    return result;
  }
  Future<Position?> getCurrent() async{
    Position position= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }
}