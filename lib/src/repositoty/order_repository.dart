import 'dart:io';

import 'package:esmp_project/src/models/feedback.dart';
import 'package:esmp_project/src/models/order.dart';
import 'package:esmp_project/src/models/order_ship.dart';

import '../constants/api.dart';
import '../constants/url.dart';
import '../models/api_response.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class OrderRepository {
  static Future<ApiResponse> createOder(
      {required int userID,
      required int amount,
      required int subItemID,
      required String token}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var response = await http
          .post(Uri.parse(AppUrl.createOrder),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode(<String, dynamic>{
                "userID": userID,
                "amount": amount,
                "sub_ItemID": subItemID,
              }))
          .timeout(Api.apiTimeOut());
      var body = json.decode(response.body);
      if (response.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {}
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

  static Future<ApiResponse> loadingOrder(
      {required int userId, required String token}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {'userID': userId.toString(), 'orderStatusID': '2'};
      String queryString = Uri(queryParameters: queryParams).query;
      var response = await http.get(
        Uri.parse('${AppUrl.getCarts}?$queryString'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Api.apiTimeOut());
      var body = json.decode(response.body);
      // log(body.toString());
      if (response.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          apiResponse.dataResponse = (body['data'] as List)
              .map((model) => Order.fromJson(model))
              .toList();
          // log( apiResponse.dataResponse.toString());
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

  static Future<ApiResponse> updateAmountOrder(
      {required String token,
      required int orderDetailID,
      required int amount}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {
        'orderDetailID': orderDetailID.toString(),
        'amount': amount.toString()
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var response = await http.put(
        Uri.parse('${AppUrl.updateAmountSubItem}?$queryString'),
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
          log(body['data'].toString());
          apiResponse.dataResponse = int.parse(body['data'].toString());
          //     Order.fromJson(body['data']);
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

  static Future<ApiResponse> removeOrderDetail(
      {required String token, required int orderDetailID}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {'orderDetailID': orderDetailID.toString()};
      String queryString = Uri(queryParameters: queryParams).query;
      log(queryString);
      var response = await http.delete(
        Uri.parse('${AppUrl.removeSubItem}?$queryString'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Api.apiTimeOut());
      var body = json.decode(response.body);
      // log(body.toString());
      if (response.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          log(body['data'].toString());
          apiResponse.dataResponse = Order.fromJson(body['data']);
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

  static Future<ApiResponse> removeOrder(
      {required String token, required int orderID}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {'orderID': orderID.toString()};
      String queryString = Uri(queryParameters: queryParams).query;
      log(queryString);
      var response = await http.delete(
        Uri.parse('${AppUrl.removeOrder}?$queryString'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Api.apiTimeOut());
      var body = json.decode(response.body);
      // log(body.toString());
      if (response.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          log(body['data'].toString());
          // apiResponse.dataResponse = int.parse(body['data']['amount'].toString());
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

  static Future<ApiResponse> getCartInfo(
      {required int orderID, required String token}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {'orderID': orderID.toString(), 'orderStatusID': '2'};
      String queryString = Uri(queryParameters: queryParams).query;
      var response = await http.get(
        Uri.parse('${AppUrl.getCartInfo}?$queryString'),
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
          apiResponse.dataResponse = Order.fromJson(body['data']);
          // log( apiResponse.dataResponse.toString());
        }
      } else {
        apiResponse.message = json.decode(response.body)['errors'].toString();
        apiResponse.isSuccess = false;
      }
    } catch (error) {
      // log(error.toString());
      apiResponse.isSuccess = false;
      apiResponse.message = "Lỗi máy chủ";
    }
    return apiResponse;
  }

  static Future<ApiResponse> updateAddressOrder(
      {required int orderID,
      required int addressID,
      required String token}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {
        'orderID': orderID.toString(),
        'AddressID': addressID.toString()
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var response = await http.put(
        Uri.parse('${AppUrl.updateAddressOrder}?$queryString'),
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
          apiResponse.dataResponse = Order.fromJson(body['data']);
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

  static Future<ApiResponse> getOldOrder(
      {required int userID,
      required int page,
      required int shipOrderStatus,
      required String token}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {
        'userID': userID.toString(),
        'shipOrderStatus': shipOrderStatus.toString(),
        'page': page.toString(),
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var response = await http.get(
        Uri.parse('${AppUrl.getOldOrder}?$queryString'),
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
          apiResponse.dataResponse = (body['data'] as List)
              .map((order) => Order.fromJson(order))
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

  static Future<ApiResponse> cancelOrder({
    required int orderID,
    required String reason,
    required String token,
  }) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {
        'orderID': orderID.toString(),
        'reason': reason,
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var response = await http.put(
        Uri.parse('${AppUrl.cancelOrder}?$queryString'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Api.apiTimeOut());
      // log(response.statusCode.toString());
      var body = json.decode(response.body);
      // log(body.toString());
      if (response.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          // log( body['data'].toString());
          // apiResponse.dataResponse=(body['data'] as List).map((order) => Order.fromJson(order)).toList();
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

  static Future<ApiResponse> feedbackOrderDetail(
      {required int orderDetailID,
      required int rate,
      required String text,
      required String token,
      required List<File> files}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var uri = Uri.parse(AppUrl.feedbackOrder);
      List<http.MultipartFile> streams = [];
      for (File file in files) {
        var streamFile = file.openRead();
        var stream = http.ByteStream(streamFile);
        stream.cast();
        var length = await file.length();
        streams.add(http.MultipartFile('feedbackImages', stream, length,
            filename: file.path.split('/').last));
      }
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
      };
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);
      request.fields['OrderDetaiID'] = orderDetailID.toString();
      request.fields['Rate'] = rate.toString();
      // log('text: $text');
      if (text.isNotEmpty) {
        request.fields['Text'] = text;
      }
      // request.files.add(http.MultipartFile('File',stream,length,filename: file.path.split('/').last));
      if (files.isNotEmpty) {
        request.files.addAll(streams);
      }
      var response = await request.send();

      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString(utf8);
        // var responseString = String.fromCharCodes(responseData);
        var body = json.decode(responseData);
        log(body.toString());
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          log(body['data'].toString());
          apiResponse.dataResponse = FeedbackModel.fromJson(body['data']);
        }
      } else {
        var responseData = await response.stream.bytesToString(utf8);
        var body = json.decode(responseData);
        log(body.toString());
        apiResponse.message = response.statusCode.toString();
        apiResponse.isSuccess = false;
      }
    } catch (error) {
      log(error.toString());
      apiResponse.message = 'Lỗi hệ thống';
      apiResponse.isSuccess = false;
    }
    return apiResponse;
  }

  static Future<ApiResponse> getOrder(
      {required int orderID, required String token}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {
        'orderID': orderID.toString(),
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var response = await http.get(
        Uri.parse('${AppUrl.getOrder}?$queryString'),
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
          apiResponse.dataResponse = Order.fromJson(body['data']);
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

  static Future<ApiResponse> getListFeedback({
    required int userID,
    required bool isFeedback,
    required int page,
    required String token,
  }) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {
        'userID': userID.toString(),
        'isFeedback': isFeedback.toString(),
        'page': page.toString(),
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var response = await http.get(
        Uri.parse('${AppUrl.getFeedbacks}?$queryString'),
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
          apiResponse.dataResponse = (body['data'] as List)
              .map((feedback) => FeedbackModel.fromJson(feedback))
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

  static Future<ApiResponse> getReOrder(
      {required int orderID, required String token}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {
        'orderID': orderID.toString(),
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var response = await http.get(
        Uri.parse('${AppUrl.getReOrder}?$queryString'),
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
          apiResponse.dataResponse = Order.fromJson(body['data']);
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

  static Future<ApiResponse> getOrderShip(
      {required int orderID, required String token}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {
        'orderID': orderID.toString(),
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var response = await http.get(
        Uri.parse('${AppUrl.getOrderShip}?$queryString'),
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
          apiResponse.dataResponse = ListShip.fromMap(body['data']);
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
