import 'dart:convert';

import 'package:esmp_project/src/constants/api.dart';
import 'package:esmp_project/src/constants/url.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:http/http.dart' as http;
class SystemRepository{
  static Future<ApiResponse> getUidSystem(
      {required String token}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var response = await http.get(
        Uri.parse(AppUrl.getAdminContact),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Api.apiTimeOut());
      var body = json.decode(response.body);
      if (response.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          apiResponse.dataResponse = body['data'] as String;
        }
      } else {
        apiResponse.message = json.decode(response.body)['errors'].toString();
        apiResponse.isSuccess = false;
      }
    } catch (error) {
      apiResponse.isSuccess = false;
      apiResponse.message = "Lỗi máy chủ";
    }
    return apiResponse;
  }
}