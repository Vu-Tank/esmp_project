import 'dart:convert';
import 'dart:developer';

import 'package:esmp_project/src/models/motor_brand.dart';

import '../constants/api.dart';
import '../constants/url.dart';
import '../models/api_response.dart';
import 'package:http/http.dart' as http;
class BrandModelRepository{
  static Future<ApiResponse> getMotorBrand()async{
    ApiResponse apiResponse=ApiResponse();
    try{
      var response= await http.get(Uri.parse(AppUrl.getBrandModel)).timeout(Api.apiTimeOut());
      // log(response.body.toString());
      if(response.statusCode==200){
        var body = json.decode(response.body);
        apiResponse.isSuccess=body['success'];
        apiResponse.message=body['message'];
        // log(body['data'].toString());
        if(apiResponse.isSuccess!){
          apiResponse.dataResponse=(body['data'] as List).map((model) => MotorBrand.fromJson(model)).toList();
        }
      }else{
        apiResponse.isSuccess=false;
        apiResponse.message=response.statusCode.toString();
      }
    }catch(error){
      apiResponse.message=error.toString();
      apiResponse.isSuccess=false;
    }
    // log(apiResponse.message.toString());
    return apiResponse;
  }
}