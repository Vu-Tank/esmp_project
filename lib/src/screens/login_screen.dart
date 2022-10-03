
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/screens/home_screen.dart';
import 'package:esmp_project/src/screens/otp_screen.dart';
import 'package:esmp_project/src/screens/register_screen.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/verify_provider.dart';
import '../repositoty/user_repository.dart';
import '../utils/widget/showSnackBar.dart';
import '../utils/widget/widget.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final verifyProvider= Provider.of<VerifyProvider>(context);
    String? _phone;
    return Scaffold(
      appBar: AppBar(
        title:const Center(child:Text("Login", style: TextStyle(color: Colors.white, fontSize: 18),)),
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
                  decoration: buildInputDecoration("Số điện thoại", Icons.phone, verifyProvider.phone.error),
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  keyboardType: TextInputType.phone,
                  onChanged: (String value){
                    verifyProvider.validatePhoneNumber(value);
                    if(verifyProvider.phone.value!=null){
                      _phone=verifyProvider.phone.value;
                    }
                  },
                ),
                //register
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const RegisterScreen()));
                          },
                          child: const Text("Đăng Ký",style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 15,
                          ),)
                      ),
                    ],
                  ),
                ),
                //login btn
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child:verifyProvider.loginPhoneStatus==Status.Authenticating
                    ? loading
                    : ElevatedButton(
                      onPressed: verifyProvider.phone.value!=null? () async{
                        _phone=Utils.convertToDB(verifyProvider.phone.value!);
                        ApiResponse apiResponse=await checkexistUserWithPhone(_phone!);
                        if(apiResponse.isSuccess!){
                          _phone=Utils.convertToFirebase(_phone!);
                          print(_phone);
                          verifyProvider.verifyPhone(
                              phoneNumber: _phone!,
                              context: context
                          );
                        }else{
                          showSnackBar(context, apiResponse.message!);
                        }
                      }:null,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      child: const Text("Login", style: TextStyle(
                          color: Colors.white,
                          fontSize: 15
                      )),
                    ),
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
