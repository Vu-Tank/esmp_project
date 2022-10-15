import 'dart:convert';
import 'dart:developer';

import 'package:esmp_project/src/constants/api.dart';
import 'package:esmp_project/src/constants/url.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/item.dart';
import 'package:http/http.dart' as http;
class ItemRepository{
  static Future<ApiResponse> getItems(int page) async{
    ApiResponse apiResponse = ApiResponse();
    try{
      final queryParams = {'statusID': '1', 'page': page.toString()};
      String queryString = Uri(queryParameters: queryParams).query;
      var response= await http.get(Uri.parse('${AppUrl.getItem}?$queryString')).timeout(Api.apiTimeOut());
      if(response.statusCode==200){
        var body = json.decode(response.body);
        apiResponse.isSuccess=body['success'];
        apiResponse.message=body['message'];
        if(apiResponse.isSuccess!){
          apiResponse.dataResponse=(body['data'] as List).map((model) => Item.fromJson(model)).toList();
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
  static Future<ApiResponse> getItemDetail(int itemId) async{
    ApiResponse apiResponse = ApiResponse();
    try{
      final queryParams = {'itemID': itemId.toString()};
      String queryString = Uri(queryParameters: queryParams).query;
      var response=await http.get(Uri.parse('${AppUrl.getItemDetail}?$queryString')).timeout(Api.apiTimeOut());
      if(response.statusCode==200){
        var body=json.decode(response.body);
        apiResponse.isSuccess=body['success'];
        apiResponse.message=body['message'];
        if(apiResponse.isSuccess!){
          apiResponse.dataResponse=ItemDetail.fromJson(body['data']);
        }
      }else{
        apiResponse.isSuccess=false;
        apiResponse.message=response.statusCode.toString();
      }
    }catch(error){
      apiResponse.isSuccess=false;
      apiResponse.message=error.toString();
    }
    return apiResponse;
  }
}