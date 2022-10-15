import 'dart:convert';
import 'dart:developer';
import 'package:esmp_project/src/constants/api.dart';
import 'package:esmp_project/src/constants/url.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/imageModel.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserRepository {
  static Future<UserModel?> getUserDetail(String phone, String idToken) async {
    UserModel? user;
    var reponse = await http.post(Uri.parse(""), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $idToken',
    }, body: {
      'phone': phone,
    }).timeout(Api.apiTimeOut());
    if (reponse.statusCode == 200) {
      user = UserModel.fromJson(jsonDecode(reponse.body));
    } else {
      log("Error at getUserDetail API: ${reponse.statusCode}");
    }
    return user;
  }

  static Future<ApiResponse> login(String phone, String firebaseToken) async {
    phone = Utils.convertToDB(phone);
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await http.post(Uri.parse(AppUrl.login),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $firebaseToken',
          },
          body: jsonEncode(<String, dynamic>{
            'phone': phone,
          })).timeout(Api.apiTimeOut());
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          apiResponse.dataResponse = UserModel.fromJson(body['data']);
        }
      } else {
        apiResponse.message = "Lỗi server";
        apiResponse.isSuccess = false;
      }
    } catch (e) {
      apiResponse.message = e.toString();
      apiResponse.isSuccess = false;
    }
    return apiResponse;
  }

  static Future<ApiResponse> checkExistUserWithPhone(String phone) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {'phone': phone, 'roleID': '2'};
      String queryString = Uri(queryParameters: queryParams).query;
      final response =
          await http.post(Uri.parse('${AppUrl.checkExistPhone}?$queryString')).timeout(Api.apiTimeOut());
      var body = json.decode(response.body);
      if (response.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        // if (apiResponse.isSuccess!) {
        //   apiResponse.dataResponse = body['data'];
        // }
      } else {
        apiResponse.message = "Lỗi server";
        apiResponse.isSuccess = false;
      }
    } catch (error) {
      apiResponse.message = 'Lỗi kết nối với máy chủ';
      apiResponse.isSuccess = false;
    }
    return apiResponse;
  }

  static Future<ApiResponse> createUser(UserModel user) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var response = await http.post(
        Uri.parse(AppUrl.register),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${user.token}',
        },
        body: jsonEncode(user.toJson()),
      ).timeout(Api.apiTimeOut());
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          apiResponse.dataResponse = UserModel.fromJson(body['data']);
        }
      } else {
        apiResponse.message = json.decode(response.body)['error'];
        apiResponse.isSuccess = false;
      }
    } catch (error) {
      apiResponse.message = 'Lỗi kết nối với máy chủ';
      apiResponse.isSuccess = false;
    }
    return apiResponse;
  }

  static Future<ApiResponse> editImage(
      {required int userId,
      required String token,
      required String path,
      required String fileName}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var response = await http.post(
        Uri.parse(AppUrl.register),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'userID': userId,
          'pathImage': path,
          'fileName': fileName,
        }),
      ).timeout(Api.apiTimeOut());
      var body = json.decode(response.body);
      if (body.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          apiResponse.dataResponse = ImageModel.fromJson(body['data']);
        }
      } else {
        apiResponse.message = json.decode(response.body)['error'];
        apiResponse.isSuccess = false;
      }
    } catch (error) {
      apiResponse.message = 'Lỗi kết nối với máy chủ';
      apiResponse.isSuccess = false;
    }
    return apiResponse;
  }

  static Future<ApiResponse> updateUserName(
      {required String userName,
      required String token,
      required int userId}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var response = await http.put(
        Uri.parse(AppUrl.register),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'userID': userId,
          'userName': userName,
        }),
      ).timeout(Api.apiTimeOut());
      var body = json.decode(response.body);
      if (body.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          apiResponse.dataResponse = UserModel.fromJson(body['data']);
        }
      } else {
        apiResponse.message = json.decode(response.body)['error'];
        apiResponse.isSuccess = false;
      }
    } catch (error) {
      log(error.toString());
      apiResponse.isSuccess = false;
      apiResponse.message = "Lỗi máy chủ";
    }
    return apiResponse;
  }

  static Future<ApiResponse> updateEmail(
      {required String email,
      required String token,
      required int userId}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var response = await http.post(
        Uri.parse(AppUrl.register),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'userID': userId,
          'email': email,
        }),
      ).timeout(Api.apiTimeOut());
      var body = json.decode(response.body);
      if (body.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          apiResponse.dataResponse = UserModel.fromJson(body['data']);
        }
      } else {
        apiResponse.message = json.decode(response.body)['error'];
        apiResponse.isSuccess = false;
      }
    } catch (error) {
      log(error.toString());
      apiResponse.isSuccess = false;
      apiResponse.message = "Lỗi máy chủ";
    }
    return apiResponse;
  }

  static Future<ApiResponse> reFeshToken(
      {required int userId, required String token}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {'userID': userId.toString(),"token" : token,};
      String queryString = Uri(queryParameters: queryParams).query;
      var response = await http.post(Uri.parse('${AppUrl.refeshtoken}?$queryString')).timeout(Api.apiTimeOut());
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          apiResponse.dataResponse = UserModel.fromJson(body['data']);
        }
      } else {
        apiResponse.message = "Lỗi server";
        apiResponse.isSuccess = false;
      }
    } catch (error) {
      apiResponse.message = error.toString();
      apiResponse.isSuccess = false;
    }
    return apiResponse;
  }
}
