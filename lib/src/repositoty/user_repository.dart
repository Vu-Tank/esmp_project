

import 'dart:convert';
import 'dart:developer';
import 'package:esmp_project/src/constants/url.dart';
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
Future<UserModel?> login(String phone, String firebaseToken) async{
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
      return UserModel.fromJson(json.decode(response.body));
    }
  }catch(e){
    print("Error at login API: $e");
  }
  return null;
}
Future<bool> checkexistUserWithPhone(String phone) async{
  try{
    final response= await http.post(Uri.parse(AppUrl.checkExistPhone),
      body: jsonEncode(<String,dynamic>{
        'phone':phone,
        'roleID': 2,
      })
    );
    if(response.statusCode==200){
      var body=json.decode(response.body);
      bool isExist=body['isExist'];
      return isExist;
    }
  }catch (error){
    print("Error at checkexistUserWithPhone API: $error");
  }
  return false;
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