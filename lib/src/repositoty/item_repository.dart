import 'dart:convert';
import 'dart:developer';

import 'package:esmp_project/src/constants/api.dart';
import 'package:esmp_project/src/constants/url.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/item.dart';
import 'package:esmp_project/src/models/search_item_model.dart';
import 'package:http/http.dart' as http;

import '../utils/utils.dart';

class ItemRepository {
  static Future<ApiResponse> getItems(int page) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {'statusID': '1', 'page': page.toString()};
      String queryString = Uri(queryParameters: queryParams).query;
      var response = await http
          .get(Uri.parse('${AppUrl.getItem}?$queryString'))
          .timeout(Api.apiTimeOut());
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        apiResponse.isSuccess = body['success'];
        apiResponse.message = body['message'];
        if (apiResponse.isSuccess!) {
          apiResponse.dataResponse = (body['data'] as List)
              .map((model) => Item.fromJson(model))
              .toList();
        }
      } else {
        apiResponse.isSuccess = false;
        apiResponse.message = response.statusCode.toString();
      }
    } catch (error) {
      apiResponse.message = error.toString();
      apiResponse.isSuccess = false;
    }
    return apiResponse;
  }

  static Future<ApiResponse> getItemDetail(int itemId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {'itemID': itemId.toString()};
      String queryString = Uri(queryParameters: queryParams).query;
      var response = await http
          .get(Uri.parse('${AppUrl.getItemDetail}?$queryString'))
          .timeout(Api.apiTimeOut());
      // log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        apiResponse.isSuccess = body['success'];
        apiResponse.message = body['message'];
        // log(body.toString());
        if (apiResponse.isSuccess!) {
          apiResponse.dataResponse = ItemDetail.fromJson(body['data']);
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

  static Future<ApiResponse> searchItems(
      SearchItemModel searchItemModel) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      Map<String, dynamic> search = searchItemModel.toJson();
      Utils.removeNullAndEmptyParams(search);
      log(search.toString());
      // Map<String, String> stringQueryParameters =
      // queryParameters.map((key, value) => MapEntry(key, value?.toString()));
      final queryParams =
          search.map((key, value) => MapEntry(key, value?.toString()));
      String queryString = Uri(queryParameters: queryParams).query;
      // log(Uri.parse('${AppUrl.seacrchItem}?$queryString').toString());
      var response = await http
          .get(Uri.parse('${AppUrl.searchItem}?$queryString'))
          .timeout(Api.apiTimeOut());
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        apiResponse.isSuccess = body['success'];
        apiResponse.message = body['message'];
        if (apiResponse.isSuccess!) {
          // log(body['data'].toString());
          apiResponse.dataResponse = (body['data'] as List)
              .map((model) => Item.fromJson(model))
              .toList();
        }
      } else {
        apiResponse.isSuccess = false;
        apiResponse.message = json.decode(response.body)['errors'].toString();
      }
    } catch (error) {
      log(error.toString());
      apiResponse.isSuccess = false;
      apiResponse.message = error.toString();
    }
    return apiResponse;
  }
  static Future<ApiResponse> addItems(
      SearchItemModel searchItemModel) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      Map<String, dynamic> search = searchItemModel.toJson();
      Utils.removeNullAndEmptyParams(search);
      // Map<String, String> stringQueryParameters =
      // queryParameters.map((key, value) => MapEntry(key, value?.toString()));
      final queryParams =
      search.map((key, value) => MapEntry(key, value?.toString()));
      String queryString = Uri(queryParameters: queryParams).query;
      // log(Uri.parse('${AppUrl.seacrchItem}?$queryString').toString());
      var response = await http
          .get(Uri.parse('${AppUrl.searchItem}?$queryString'))
          .timeout(Api.apiTimeOut());
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        apiResponse.isSuccess = body['success'];
        apiResponse.message = body['message'];
        if (apiResponse.isSuccess!) {
          apiResponse.dataResponse = (body['data'] as List)
              .map((model) => Item.fromJson(model))
              .toList();
        }
      } else {
        apiResponse.isSuccess = false;
        apiResponse.message = json.decode(response.body)['errors'].toString();
      }
    } catch (error) {
      log(error.toString());
      apiResponse.isSuccess = false;
      apiResponse.message = error.toString();
    }
    return apiResponse;
  }
}
