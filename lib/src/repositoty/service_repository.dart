import 'dart:convert';
import 'dart:developer';

import 'package:esmp_project/src/constants/api.dart';
import 'package:esmp_project/src/constants/url.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/service_detail.dart';
import 'package:esmp_project/src/models/service_order_detail.dart';
import 'package:http/http.dart' as http;

class ServiceRepository {
  static Future<ApiResponse> createReturnSevice(
      {required String token,
      required int orderId,
      required int addressId,
      required int serviceType,
      required String create_Date,
      required String packingLinkCus,
      required List<ServiceDetail> list_ServiceDetail,
      required String reason}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await http
          .post(Uri.parse(AppUrl.getServiceAfterBuy),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode(<String, dynamic>{
                "create_Date": create_Date.replaceAll(
                  RegExp(r' '),
                  'T',
                ),
                "packingLinkCus": packingLinkCus,
                "list_ServiceDetail": List<String>.from(
                        list_ServiceDetail.map((e) => e.toJson().toString()))
                    .toString(),
                "orderID": orderId,
                "addressID": addressId,
                "serviceType": serviceType,
                "text": reason,
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

  static Future<ApiResponse> getDetailAfterService(
      {required String token,
      int? userID,
      int? storeID,
      int? serviceID,
      int? serviceType,
      int? page}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {
        'userID': userID.toString(),
        'storeID': storeID == null ? "" : storeID.toString(),
        'serviceID': serviceID == null ? "" : serviceID.toString(),
        'serviceType': serviceType == null ? "" : serviceType.toString(),
        'page': page == null ? "" : page.toString(),
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var response = await http.get(
        Uri.parse('${AppUrl.getServiceAfterBuy}?$queryString'),
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
              .map((model) => ServiceOrderDetail.fromMap(model))
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
}
