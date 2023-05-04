import 'dart:convert';
import 'dart:developer';

import 'package:esmp_project/src/models/api_response.dart';
import 'package:http/http.dart' as http;

import '../constants/api.dart';
import '../constants/url.dart';

class PaymentRepository {
  static Future<ApiResponse> paymentOrder(
      {required int orderID,
      required String paymentMethod,
      required String token}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      log("payment$paymentMethod");
      final queryParams = {
        'orderID': orderID.toString(),
        'paymentMethod': paymentMethod,
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var response = await http.get(
        Uri.parse('${AppUrl.payment}?$queryString'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Api.apiTimeOut());

      // log(response.statusCode.toString());
      var body = json.decode(response.body);
      if (response.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          // log( body['data'].toString());
          if (paymentMethod == "MOMO") {
            apiResponse.dataResponse = body['data']['deeplink'];
          } else {
            apiResponse.dataResponse = body['data'];
          }
        }
      } else {
        apiResponse.message = json.decode(response.body)['errors'].toString();
        apiResponse.isSuccess = false;
      }
    } catch (error) {
      log("loi$error");
      apiResponse.isSuccess = false;
      apiResponse.message = "Lỗi máy chủ";
    }
    return apiResponse;
  }

  static Future<ApiResponse> checkPaymentOrder(
      {required String orderID, required String token}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {
        'orderID': orderID,
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var response = await http.get(
        Uri.parse('${AppUrl.checkPayment}?$queryString'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Api.apiTimeOut());

      // log(response.statusCode.toString());
      var body = json.decode(response.body);
      if (response.statusCode == 200) {
        log(body.toString());
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          // log( body['data'].toString());
          apiResponse.dataResponse = body['data'] as int;
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
