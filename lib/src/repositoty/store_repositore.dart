import 'dart:convert';

import 'package:esmp_project/src/constants/api.dart';
import 'package:esmp_project/src/constants/url.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/store.dart';
import 'package:http/http.dart' as http;
class StoreRepository{
  static Future<ApiResponse> getStoreInfo({required int storeId})async{
    ApiResponse apiResponse=ApiResponse();
    try {
      final queryParams = {'storeID': storeId.toString()};
      String queryString = Uri(queryParameters: queryParams).query;
      var response = await http
          .get(Uri.parse('${AppUrl.getItemDetail}?$queryString'))
          .timeout(Api.apiTimeOut());
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        apiResponse.isSuccess = body['success'];
        apiResponse.message = body['message'];
        if (apiResponse.isSuccess!) {
          apiResponse.dataResponse = Store.fromJson(body['data']);
        }
      } else {
        apiResponse.isSuccess = false;
        apiResponse.message = response.statusCode.toString();
      }
    } catch (error) {
      apiResponse.isSuccess = false;
      apiResponse.message = error.toString();
    }
    return apiResponse;
  }
  static Future<ApiResponse> checkStore(String firebaseID,String token) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {'firebaseID': firebaseID};
      String queryString = Uri(queryParameters: queryParams).query;
      final response = await http.get(Uri.parse('${AppUrl.checkStore}?$queryString'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Api.apiTimeOut());
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          // apiResponse.dataResponse = UserModel.fromJson(body['data']);
        }
      } else {
        apiResponse.message = json.decode(response.body)['errors'].toString();
        apiResponse.isSuccess = false;
      }
    } catch (e) {
      apiResponse.message = e.toString();
      apiResponse.isSuccess = false;
    }
    return apiResponse;
  }
}