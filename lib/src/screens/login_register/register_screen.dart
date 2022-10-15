
import 'dart:developer';

import 'package:esmp_project/src/screens/login_register/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/api_response.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../../providers/verify_provider.dart';
import '../../repositoty/user_repository.dart';
import '../../utils/utils.dart';
import '../../utils/widget/loading_dialog.dart';
import '../../utils/widget/showSnackBar.dart';
import '../../utils/widget/widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _phoneController=TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VerifyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Đăng Ký",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: <Widget>[
                //textfiel Phone number
                TextField(
                  decoration: buildInputDecoration(
                      "Số điện thoại", Icons.phone, provider.phone.error),
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  keyboardType: TextInputType.number,
                  controller: _phoneController,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () async{
                        if (provider
                            .validPhoneNumber(_phoneController.text.trim())) {
                          try {
                            LoadingDialog.showLoadingDialog(
                                context, "Vui lòng đợi");
                            String phone =Utils.convertToFirebase(_phoneController.text.trim());
                            phone =Utils.convertToDB(phone);
                            ApiResponse apiResponse =
                            await UserRepository.checkExistUserWithPhone(
                                phone);
                            log(apiResponse.toString());
                            if (!apiResponse.isSuccess!) {
                              phone = Utils.convertToFirebase(
                                  _phoneController.text.trim());
                              await provider.verifyPhone(
                                  phoneNumber: phone,
                                  context: context,
                                  status: 'register',
                                  onFailed: (String msg) {
                                    showSnackBar(context, msg);
                                  },
                                  onLogin: (UserModel user) {
                                    context.read<UserProvider>().setUser(user);
                                    Navigator.pushReplacementNamed(
                                        context, "/main");
                                  },
                                  onRegister: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OTPScreen(
                                              phone: phone,
                                              status: "register",
                                            )));
                                  });
                              if(mounted){
                                LoadingDialog.hideLoadingDialog(context);
                              }
                            } else {
                              if (mounted) {
                                LoadingDialog.hideLoadingDialog(context);
                                showSnackBar(context, apiResponse.message!);
                              }
                            }
                          } catch (error) {
                            if (mounted) {
                              LoadingDialog.hideLoadingDialog(context);
                              showSnackBar(context, error.toString());
                            }
                          }
                        }
                      },
                      // onPressed: () async{
                      //   if(provider.phone.value != null){
                      //     LoadingDialog.showLoadingDialog(context, 'Vui lòng đợi');
                      //     try{
                      //       _phone = Utils.convertToDB(provider.phone.value!);
                      //       ApiResponse apiResponse =
                      //       await UserRepository.checkExistUserWithPhone(
                      //           _phone!);
                      //       if (!apiResponse.isSuccess!) {
                      //         _phone=Utils.convertToFirebase(_phone!);
                      //         await provider.verifyPhone(
                      //             phoneNumber: _phone!,
                      //             context: context,
                      //             status: 'register',
                      //             onFailed: (String msg){
                      //               showSnackBar(context, msg);
                      //             },
                      //             onLogin: (){
                      //             },
                      //             onRegister: (String token){
                      //               Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterInfoScreen(token: token, phone: _phone!,)));
                      //             }
                      //         );
                      //       }else{
                      //         if(mounted)showSnackBar(context, apiResponse.message!);
                      //       }
                      //     }finally{
                      //       LoadingDialog.hideLoadingDialog(context);
                      //     }
                      //   }else{
                      //     null;
                      //   }
                      // },
                      label: const Text("Gửi OTP",
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 15,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
