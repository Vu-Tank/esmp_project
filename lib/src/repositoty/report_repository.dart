import 'dart:convert';
import 'dart:developer';

import 'package:esmp_project/src/constants/api.dart';
import 'package:esmp_project/src/constants/url.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:http/http.dart' as http;
class ReportRepository{
  static Future<ApiResponse> reportItem(
      {required int itemID,
        required int userID,
        required String text,
        required String token}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var response = await http.post(
        Uri.parse(AppUrl.reportItem),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "itemID": itemID.toString(),
          "userID": userID.toString(),
          "text": text,
        }),
      ).timeout(Api.apiTimeOut());
      var body = json.decode(response.body);
      log(body.toString());
      if (response.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
        }
      } else {
        apiResponse.message = json.decode(response.body)['errors'].toString();
        apiResponse.isSuccess = false;
      }
    } catch (error) {
      log(error.toString());
      apiResponse.isSuccess = false;
      apiResponse.message = "Lỗi máy chủ";
    }
    return apiResponse;
  }
  static Future<ApiResponse> reportStore(
      {required int storeID,
        required int userID,
        required String text,
        required String token}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var response = await http.post(
        Uri.parse(AppUrl.reportStore),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "storeID": storeID.toString(),
          "userID": userID.toString(),
          "text": text,
        }),
      ).timeout(Api.apiTimeOut());
      var body = json.decode(response.body);
      log(body.toString());
      if (response.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
        }
      } else {
        apiResponse.message = json.decode(response.body)['errors'].toString();
        apiResponse.isSuccess = false;
      }
    } catch (error) {
      log(error.toString());
      apiResponse.isSuccess = false;
      apiResponse.message = "Lỗi máy chủ";
    }
    return apiResponse;
  }
  static Future<ApiResponse> reportFeedback(
      {required int orderDetailID,
        required int userID,
        required String text,
        required String token}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var response = await http.post(
        Uri.parse(AppUrl.reportFeedback),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "orderDetailID": orderDetailID.toString(),
          "userID": userID.toString(),
          "text": text,
        }),
      ).timeout(Api.apiTimeOut());
      var body = json.decode(response.body);
      log(body.toString());
      if (response.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
        }
      } else {
        apiResponse.message = json.decode(response.body)['errors'].toString();
        apiResponse.isSuccess = false;
      }
    } catch (error) {
      log(error.toString());
      apiResponse.isSuccess = false;
      apiResponse.message = "Lỗi máy chủ";
    }
    return apiResponse;
  }
}