import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/validation_item.dart';
import 'package:esmp_project/src/repositoty/user_repository.dart';
import 'package:esmp_project/src/utils/validations.dart';
import 'package:flutter/material.dart';

class EditProfileProvider extends ChangeNotifier{
  ValidationItem validationItem= ValidationItem(null, null);

  ValidationItem validItem({required String? value, required String status}){
    switch(status){
      case 'userName':
          validationItem = Validations.validUserName(value);
          notifyListeners();
        break;
      case 'email':
        validationItem=Validations.valEmail(value);
        notifyListeners();
        break;
    }
    return validationItem;
  }
  Future<ApiResponse> updateProfile({required String value,required String status,required String token,required int userId}) async{
    ApiResponse apiResponse= ApiResponse();
    switch(status){
      case 'userName':
        apiResponse=await UserRepository.updateUserName(userName: value, token: token, userId: userId);
        validationItem=ValidationItem(null, null);
        break;
      case 'email':
        apiResponse= await UserRepository.updateEmail(email: value, token: token, userId: userId);
        validationItem=ValidationItem(null, null);
        break;
    }
    return apiResponse;
  }
}