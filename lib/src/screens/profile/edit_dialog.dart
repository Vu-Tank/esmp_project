import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/models/validation_item.dart';
import 'package:esmp_project/src/providers/user/edit_profile_provider.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/showSnackBar.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditDialog {
  Future openDialog(
          {required BuildContext context,
          required String title,
          required String hintText,
          required String status,
          required String token,
          required int userId,
          required Function onSuccess,
          required Function onFailed,
          required TextEditingController controller}) =>
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final editProvider = Provider.of<EditProfileProvider>(context);
          String value = "";
          return AlertDialog(
            title: Text(
              title,
              style: textStyleInput,
            ),
            content: TextField(
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: textStyleLabelChild,
                errorStyle: textStyleError,
                errorText: editProvider.validationItem.error,
              ),
              controller: controller,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    controller.clear();
                    Navigator.pop(context);
                  },
                  child: Text('Thoát', style: TextStyle(fontSize: 16, color: mainColor),)),
              TextButton(
                  onPressed: () async {
                    editProvider.validItem(
                        value: controller.text, status: status);
                    if (editProvider.validationItem.value != null) {
                      ApiResponse apiResponse =
                          await editProvider.updateProfile(
                              value: controller.text,
                              status: status,
                              token: token,
                              userId: userId);
                      if (apiResponse.isSuccess!) {
                        onSuccess(apiResponse.dataResponse as UserModel);
                      } else {
                        onFailed(apiResponse.message!);
                      }
                    }
                  },
                  child: Text('Xác Nhận', style: TextStyle(fontSize: 16, color: mainColor),)),
            ],
          );
        },
      );

  Future openDialogGender(
          {required BuildContext context,
          required int userId,
          required String gender,
          required String token,
          required Function onSuccess,
          required Function onFailed}) =>
      showDialog(
        context: context,
        builder: (context) {
          final editProvider = Provider.of<EditProfileProvider>(context);
          return AlertDialog(
            alignment: Alignment.center,
            title: Center(
              child: Text(
                "Giới tính",
                style: textStyleInput,
              ),
            ),
            actions: [
              InkWell(
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black12),
                      top: BorderSide(color: Colors.black12),
                    ),
                  ),
                  child: Text(
                    'Nam',
                    style: textStyleInput,
                  ),
                ),
                onTap: () async{
                  LoadingDialog.showLoadingDialog(context, "Vui lòng đợi");
                  ApiResponse apiResponse=await editProvider.updateProfile(value: 'Nam', status: 'gender', token: token, userId: userId);
                  if(apiResponse.isSuccess!){
                    onSuccess(apiResponse.dataResponse as UserModel);
                  }else{
                    onFailed(apiResponse.message!);
                  }
                },
              ),
              InkWell(
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black12),
                      top: BorderSide(color: Colors.black12),
                    ),
                  ),
                  child: Text(
                    'Nữ',
                    style: textStyleInput,
                  ),
                ),
                onTap: () async{
                  LoadingDialog.showLoadingDialog(context, "Vui lòng đợi");
                  ApiResponse apiResponse=await editProvider.updateProfile(value: 'Nữ', status: 'gender', token: token, userId: userId);
                  if(apiResponse.isSuccess!){
                    onSuccess(apiResponse.dataResponse as UserModel);
                  }else{
                    onFailed(apiResponse.message!);
                  }
                },
              ),
              InkWell(
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black12),
                      top: BorderSide(color: Colors.black12),
                    ),
                  ),
                  child: Text(
                    'Khác',
                    style: textStyleInput,
                  ),
                ),
                onTap: () async{
                  LoadingDialog.showLoadingDialog(context, "Vui lòng đợi");
                  ApiResponse apiResponse=await editProvider.updateProfile(value: 'Khác', status: 'gender', token: token, userId: userId);
                  if(apiResponse.isSuccess!){
                    onSuccess(apiResponse.dataResponse as UserModel);
                  }else{
                    onFailed(apiResponse.message!);
                  }
                },
              ),
            ],
          );
        },
      );

}
