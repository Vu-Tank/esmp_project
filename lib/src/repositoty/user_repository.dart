
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../models/user.dart';
Future<User?> getUserDetail(String phone, String idToken) async{
  User? user=null;
  var reponse= await http.post(Uri.parse(""),
    headers:{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + idToken,
    },
    body:{
      'phone': phone,
    }
  );
  if(reponse.statusCode==200){
    user=User.fromJson(jsonDecode(reponse.body));
  }else{
    log(reponse.statusCode.toString());
  }
  return user;
}
Future<bool> createUser(User user) async{
  var reponse = await http.post(Uri.parse(""),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + user.token,
    },
    body: user.toJson(),
  );
  if(reponse.statusCode==200){
    return true;
  }
  log("error: "+jsonDecode(reponse.body));
  return false;
}