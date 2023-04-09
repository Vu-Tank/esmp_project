import 'dart:convert';
import 'dart:developer';

import 'package:esmp_project/src/constants/api.dart';
import 'package:esmp_project/src/constants/url.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/data_exchange.dart';
import 'package:http/http.dart' as http;

class DataExchangeRepository {
  static Future<ApiResponse> getDataExchange(
      {required String token,
      required int userID,
      required int page,
      int? orderID,
      int? serviceID}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {
        'userID': userID.toString(),
        'page': page.toString(),
        'orderID': orderID == null ? "" : orderID.toString(),
        'serviceID': serviceID == null ? "" : serviceID.toString()
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var response = await http.get(
        Uri.parse('${AppUrl.getDataExchange}?$queryString'),
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
          // log( body['data'].toString());
          apiResponse.dataResponse = (body['data'] as List)
              .map((model) => DataExchange.fromMap(model))
              .toList();
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

  static Future<ApiResponse> addCard(
      {required String token,
      required int exchangeUserID,
      required String bankName,
      required String cardNum,
      required String cardHoldName}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await http
          .put(Uri.parse(AppUrl.addCardDataExchange),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode(<String, dynamic>{
                "exchangeUserID": exchangeUserID,
                "bankName": bankName,
                "cardNum": cardNum,
                "cardHoldName": cardHoldName,
              }))
          .timeout(Api.apiTimeOut());
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        // var responseString = String.fromCharCodes(responseData);
        var body = json.decode(response.body);
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {}
      } else {
        apiResponse.message = response.statusCode.toString();
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
