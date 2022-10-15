import 'dart:developer';

import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/screens/login_register/register_screen.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/verify_provider.dart';
import '../../repositoty/user_repository.dart';
import '../../utils/widget/showSnackBar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verifyProvider = Provider.of<VerifyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Login",
          style: TextStyle(color: Colors.white, fontSize: 18),
        )),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: <Widget>[
                //logo
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: FlutterLogo(
                    size: 100,
                  ),
                ),
                TextField(
                  decoration: buildInputDecoration(
                      "Số điện thoại", Icons.phone, verifyProvider.phone.error),
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                ),
                //register
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen()));
                          },
                          child: const Text(
                            "Đăng Ký",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 15,
                            ),
                          )),
                    ],
                  ),
                ),
                //login btn
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (verifyProvider
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
                            if (apiResponse.isSuccess!) {
                              phone = Utils.convertToFirebase(
                                  _phoneController.text.trim());
                              await verifyProvider.verifyPhone(
                                  phoneNumber: phone,
                                  context: context,
                                  status: 'login',
                                  onFailed: (String msg) {
                                    showSnackBar(context, msg);
                                  },
                                  onLogin: (UserModel user) {
                                    context.read<UserProvider>().setUser(user);
                                    Navigator.pushReplacementNamed(
                                        context, "/main");
                                  },
                                  onRegister: () {});
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      child: const Text("Đăng nhập",
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                    ),
                    // child:verifyProvider.loginPhoneStatus==Status.Authenticating
                    // ? loading
                    // : ElevatedButton(
                    //   onPressed: verifyProvider.phone.value!=null? () async{
                    //     phone=Utils.convertToDB(verifyProvider.phone.value!);
                    //     ApiResponse apiResponse=await UserRepository.checkExistUserWithPhone(phone!);
                    //     if(apiResponse.isSuccess!){
                    //       phone=Utils.convertToFirebase(phone!);
                    //       await verifyProvider.verifyPhone(
                    //           phoneNumber: phone!,
                    //           context: context,
                    //           status: 'login',
                    //           onFailed: (String msg){
                    //             showSnackBar(context, msg);
                    //           },
                    //           onLogin: (UserModel user){
                    //             context.read<UserProvider>().setUser(user);
                    //             Navigator.pushReplacementNamed(context, "/main");
                    //           },
                    //           onRegister: (){
                    //           }
                    //       );
                    //     }else{
                    //       if(mounted) {
                    //         showSnackBar(context, apiResponse.message!);
                    //       }
                    //     }
                    //   }:null,
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.blue,
                    //     shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    //   ),
                    //   child: const Text("Login", style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 15
                    //   )),
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
