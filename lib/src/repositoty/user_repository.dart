
import 'dart:convert';
import 'dart:developer';
import 'package:esmp_project/src/constants/url.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
Future<UserModel?> getUserDetail(String phone, String idToken) async{
  UserModel? user;
  var reponse= await http.post(Uri.parse(""),
    headers:{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $idToken',
    },
    body:{
      'phone': phone,
    }
  );
  if(reponse.statusCode==200){
    user=UserModel.fromJson(jsonDecode(reponse.body));
  }else{
    print("Error at getUserDetail API: ${reponse.statusCode}");
  }
  return user;
}
Future<ApiResponse> login(String phone, String firebaseToken) async{
  phone=Utils.convertToDB(phone);
  ApiResponse apiResponse= new ApiResponse();
  try{
    final response= await http.post(Uri.parse(AppUrl.login),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $firebaseToken',
        },
        body: jsonEncode(<String,dynamic>{
          'phone':phone,
        })
    );
    if(response.statusCode==200){
      var body=json.decode(response.body);
      // print(body['data']);
      apiResponse.dataResponse= UserModel.fromJson(body['data']);
      apiResponse.message=body['message'];
      apiResponse.isSuccess=body['success'];
    }else{
      apiResponse.message= "Lỗi server";
      apiResponse.isSuccess=false;
    }
  }catch(e){
    print(e.toString());
    apiResponse.message= e.toString();
    apiResponse.isSuccess=false;
  }
  return apiResponse;
}
Future<ApiResponse> checkexistUserWithPhone(String phone) async{
  ApiResponse apiResponse= new ApiResponse();
  try{
    final queryParams = {
      'phone': '$phone',
      'roleID':'2'
    };
    String queryString = Uri(queryParameters: queryParams).query;
    final response= await http.post(Uri.parse(AppUrl.checkExistPhone+'?' + queryString));
    var body=json.decode(response.body);
    if(response.statusCode==200){
      apiResponse.dataResponse= body['data'];
      apiResponse.message=body['message'];
      apiResponse.isSuccess=body['success'];
    }else{
      apiResponse.message= json.decode(response.body)['error'];
      apiResponse.isSuccess=false;
    }
  }catch (error){
    print(error.toString());
    apiResponse.message= error.toString();
    apiResponse.isSuccess=false;
  }
  return apiResponse;
}
Future<bool> createUser(UserModel user) async{
  var reponse = await http.post(Uri.parse(""),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${user.token!}',
    },
    body: user.toJson(),
  );
  if(reponse.statusCode==200){
    return true;
  }
  log("error: "+jsonDecode(reponse.body));
  return false;
}
