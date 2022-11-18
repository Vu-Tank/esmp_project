import 'dart:async';

import 'package:esmp_project/src/screens/payment_result/payment_result.dart';
import 'package:flutter/material.dart';

class WaitingCallbackMomo extends StatefulWidget {
  const WaitingCallbackMomo({Key? key, required this.queryParams}) : super(key: key);

  final Map queryParams;

  @override
  State<WaitingCallbackMomo> createState() => _WaitingCallbackMomoState();
}

class _WaitingCallbackMomoState extends State<WaitingCallbackMomo> {
  late Timer _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer= Timer.periodic(const Duration(seconds: 10), (timer) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PaymentResult(queryParams: widget.queryParams)));
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 50,),
            Text('Đang tiến hành thanh toán', style: TextStyle(
              color: Colors.grey,
              fontSize: 20
            ),)
          ],
        ),
      ),
    );
  }
}
