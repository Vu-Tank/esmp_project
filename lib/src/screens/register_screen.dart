
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/verify_provider.dart';
import '../utils/widget/widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? _phone="";
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VerifyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Đăng Ký", style: TextStyle(color: Colors.white, fontSize: 18,)),
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
                  onChanged: (String value) => {
                    provider.validatePhoneNumber(value),
                    if(provider.phone.value!=null){
                      _phone=provider.phone.value
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: provider.phone.value!=null ? (){
                        provider.verifyPhone(_phone!, context);
                      }:null,
                      label: const Text("Gửi OTP", style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                        )
                      ),
                      icon: const Icon(Icons.send, color: Colors.white, size: 15,),
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
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
