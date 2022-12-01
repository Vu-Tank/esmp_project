import 'dart:convert';

import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/category.dart';
import 'package:http/http.dart' as http;

import '../constants/api.dart';
import '../constants/url.dart';

class CategoryRepository{
  static Future<ApiResponse> getCategory()async{
    ApiResponse apiResponse=ApiResponse();
    try{
      var response= await http.get(Uri.parse(AppUrl.getCategory)).timeout(Api.apiTimeOut());
      if(response.statusCode==200){
        var body = json.decode(response.body);
        apiResponse.isSuccess=body['success'];
        apiResponse.message=body['message'];
        if(apiResponse.isSuccess!){
          apiResponse.dataResponse=(body['data'] as List).map((model) => Category.fromJson(model)).toList();
        }
      }else{
        apiResponse.isSuccess=false;
        apiResponse.message=response.statusCode.toString();
      }
    }catch(error){
      apiResponse.message=error.toString();
      apiResponse.isSuccess=false;
    }
    return apiResponse;
  }
}