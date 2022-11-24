import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:esmp_project/src/constants/api.dart';
import 'package:esmp_project/src/constants/url.dart';
import 'package:esmp_project/src/models/address.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/imageModel.dart';
import 'package:http_parser/http_parser.dart';
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

  static Future<ApiResponse> login(String phone, String firebaseToken, String? fcmToken) async {
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
            'fcM_Firebase': fcmToken,
          })).timeout(Api.apiTimeOut());
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          apiResponse.dataResponse = UserModel.fromJson(body['data']);
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
        apiResponse.message = json.decode(response.body)['errors'].toString();
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
        apiResponse.message = json.decode(response.body)['errors'].toString();
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
      required File file}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var uri = Uri.parse(AppUrl.editImage);
      var streamFile=file.openRead();
      var stream=http.ByteStream(streamFile);
      stream.cast();
      var length=await file.length();
      Map<String, String> headers ={
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
      };
      var request = http.MultipartRequest('PUT', uri);
      request.headers.addAll(headers);
      request.fields['UserID']=userId.toString();
      request.files.add(http.MultipartFile('File',stream,length,filename: file.path.split('/').last));
      // request.files.add(http.MultipartFile('File',file.readAsBytes().asStream(),file.lengthSync(),filename: file.path.split('/').last));
      var response=await request.send();

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
          apiResponse.dataResponse = UserModel.fromJson(body['data']);
        }
      } else {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);

        var body = json.decode(responseString);
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

  static Future<ApiResponse> updateUserName(
      {required String userName,
      required String token,
      required int userId}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var response = await http.put(
        Uri.parse(AppUrl.editUserName),
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
      log(response.statusCode.toString());
      log(body.toString());
      if (response.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          apiResponse.dataResponse = UserModel.fromJson(body['data']);
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

  static Future<ApiResponse> updateEmail(
      {required String email,
      required String token,
      required int userId}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var response = await http.put(
        Uri.parse(AppUrl.editEmail),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'userID': userId,
          'userEmail': email,
        }),
      ).timeout(Api.apiTimeOut());
      var body = json.decode(response.body);
      if (response.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          apiResponse.dataResponse = UserModel.fromJson(body['data']);
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
        apiResponse.message = json.decode(response.body)['errors'].toString();
        apiResponse.isSuccess = false;
      }
    } catch (error) {
      apiResponse.message = error.toString();
      apiResponse.isSuccess = false;
    }
    return apiResponse;
  }
  static Future<ApiResponse> updateGender(
      {required String gender,
        required String token,
        required int userId}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var response = await http.put(
        Uri.parse(AppUrl.editGender),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'userID': userId,
          'userGender': gender,
        }),
      ).timeout(Api.apiTimeOut());
      var body = json.decode(response.body);
      if (response.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          apiResponse.dataResponse = UserModel.fromJson(body['data']);
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
  static Future<ApiResponse> updateDOB(
      {required String dob,
        required String token,
        required int userId}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var response = await http.put(
        Uri.parse(AppUrl.editDOB),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'userID': userId,
          'userBirth': dob,
        }),
      ).timeout(Api.apiTimeOut());
      var body = json.decode(response.body);
      if (response.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          apiResponse.dataResponse = UserModel.fromJson(body['data']);
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
  static Future<ApiResponse> updateAddress(
      {required AddressModel addressModel,
        required String token}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      log(addressModel.toString());
      var response = await http.put(
        Uri.parse(AppUrl.editAddress),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "addressID": addressModel.addressID,
          "userName": addressModel.userName,
          "phone": addressModel.userPhone,
          "context": addressModel.context,
          "province": addressModel.province,
          "district": addressModel.district,
          "ward": addressModel.province,
          "latitude": addressModel.latitude,
          "longitude": addressModel.longitude,
          "isActive": true
        }),
      ).timeout(Api.apiTimeOut());
      var body = json.decode(response.body);
      if (response.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          apiResponse.dataResponse = AddressModel.fromJson(body['data']);
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
  static Future<ApiResponse> createAddress(
      {required AddressModel addressModel,
        required int userID,
        required String token}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var response = await http.post(
        Uri.parse(AppUrl.createAddress),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "userID": userID,
          "userName": addressModel.userName,
          "phone": addressModel.userPhone,
          "contextAddress": addressModel.context,
          "province": addressModel.province,
          "district": addressModel.district,
          "ward": addressModel.ward,
          "latitude": addressModel.latitude,
          "longitude": addressModel.longitude
        }),
      ).timeout(Api.apiTimeOut());
      var body = json.decode(response.body);
      if (response.statusCode == 200) {
        apiResponse.message = body['message'];
        apiResponse.isSuccess = body['success'];
        if (apiResponse.isSuccess!) {
          log(body['data'].toString());
          apiResponse.dataResponse = (body['data'] as List).map((model) => AddressModel.fromJson(model)).toList();
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
  static Future<ApiResponse> deleteAddress(
      {required int addressID,
        required String token}) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {'addressID': addressID.toString()};
      String queryString = Uri(queryParameters: queryParams).query;
      var response = await http.delete(
        Uri.parse('${AppUrl.deleteAddress}?$queryString'),
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
          // apiResponse.dataResponse = (body['data'] as List).map((model) => AddressModel.fromJson(model)).toList();
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
  static Future<ApiResponse> logout(int userID,String token) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final queryParams = {'userID': userID.toString()};
      String queryString = Uri(queryParameters: queryParams).query;
      final response = await http.post(Uri.parse('${AppUrl.logout}?$queryString'),
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
