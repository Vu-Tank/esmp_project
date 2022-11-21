import 'dart:developer';
import 'dart:io';

import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/imageModel.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/models/validation_item.dart';
import 'package:esmp_project/src/repositoty/cloud_firestore_service.dart';
import 'package:esmp_project/src/repositoty/user_repository.dart';
import 'package:esmp_project/src/utils/validations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../repositoty/firebase_storage.dart';
import '../../utils/utils.dart';

class EditProfileProvider extends ChangeNotifier {
  ValidationItem validationItem = ValidationItem(null, null);

  ValidationItem validItem({required String? value, required String status}) {
    switch (status) {
      case 'userName':
        validationItem = Validations.validUserName(value);
        notifyListeners();
        break;
      case 'email':
        validationItem = Validations.valEmail(value);
        notifyListeners();
        break;
    }
    return validationItem;
  }

  Future<ApiResponse> updateProfile(
      {required String value,
      required String status,
      required String token,
      required int userId}) async {
    ApiResponse apiResponse = ApiResponse();
    switch (status) {
      case 'userName':
        apiResponse = await UserRepository.updateUserName(
            userName: value, token: token, userId: userId);
        if(apiResponse.isSuccess!){
          await CloudFirestoreService(uid: FirebaseAuth.instance.currentUser!.uid).updateUserName(value);
        }
        validationItem = ValidationItem(null, null);
        break;
      case 'email':
        apiResponse = await UserRepository.updateEmail(
            email: value, token: token, userId: userId);
        validationItem = ValidationItem(null, null);
        break;
      case 'gender':
        apiResponse = await UserRepository.updateGender(
            gender: value, token: token, userId: userId);
        validationItem = ValidationItem(null, null);
        break;
      case 'dob':
        apiResponse = await UserRepository.updateDOB(
            dob: value, token: token, userId: userId);
        validationItem = ValidationItem(null, null);
        break;
    }
    return apiResponse;
  }

  Future<void> editImage(
      {required File image,
      required int userID,
      required String token,
      required String userImage,
      required Function onSuccess,
      required Function onFailed}) async {
    // if (userImage != 'defaultAvatar.png') {
    //   await FirebaseStorageService().deleteFile(userImage).catchError((error){
    //     if(error.toString().contains('object-not-found')){
    //       log(error.toString());
    //     }
    //   });
    // }else{
    //     userImage=image.path.split('/').last;
    //     String exFileName=userImage.split('.').last;
    //     userImage='eSMP${Utils.createFile()}.$exFileName';
    // }
    // String? urlImage =
    //     await FirebaseStorageService().uploadFile(image, userImage).catchError((error){
    //       onFailed(error.toString());
    //     });
    // if(urlImage!=null){
      ApiResponse apiResponse = await UserRepository.editImage(
          userId: userID, token: token,file: image);
      if (apiResponse.isSuccess!) {
        onSuccess(apiResponse.dataResponse as UserModel);
        // userProvider.setUser(apiResponse.dataResponse as UserModel);
      }else{
        onFailed(apiResponse.message!);
      }
    // }
  }
}
