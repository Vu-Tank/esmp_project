import 'dart:async';

import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/providers/main_screen_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/repositoty/payment_repository.dart';
import 'package:esmp_project/src/screens/main/main_screen.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentResult extends StatefulWidget {
  const PaymentResult({Key? key, required this.queryParams}) : super(key: key);
  final Map queryParams;
  @override
  State<PaymentResult> createState() => _PaymentResultState();
}

class _PaymentResultState extends State<PaymentResult> {
  late Timer _timer;
  late Future<ApiResponse> _data;
  int checkPay = 1;
  @override
  void dispose() {
    // TODO: implement dispose
    if (checkPay == 3) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _data = checkPaymentOrder();
    if (checkPay == 3) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        setState(() {
          _data = checkPaymentOrder();
        });
      });
    }
  }

  Future<ApiResponse> checkPaymentOrder() async {
    return await PaymentRepository.checkPaymentOrder(
        orderID: widget.queryParams['orderID'],
        token: context.read<UserProvider>().user!.token!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        child: FutureBuilder(
          future: _data,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error!
                        .toString()
                        .replaceAll('Exception:', '')),
                  );
                } else {
                  if (snapshot.data!.isSuccess!) {
                    checkPay = snapshot.data!.dataResponse!;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                              size: 200,
                            ),
                          ),
                          Text(
                            snapshot.data!.message!,
                            style: const TextStyle(
                                color: Colors.green, fontSize: 20),
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          if (checkPay != 3)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 53,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<MainScreenProvider>()
                                        .changePage(0);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MainScreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: btnColor,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                  ),
                                  child: Text("Về màn hình chính",
                                      style: btnTextStyle),
                                ),
                              ),
                            )
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Icon(
                              Icons.error_outline_outlined,
                              color: Colors.red,
                              size: 200,
                            ),
                          ),
                          Text(
                            snapshot.data!.message!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 20),
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          if (checkPay != 3)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 53,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<MainScreenProvider>()
                                        .changePage(0);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MainScreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: btnColor,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                  ),
                                  child: Text("Về màn hình chính",
                                      style: btnTextStyle),
                                ),
                              ),
                            )
                        ],
                      ),
                    );
                  }
                }
            }
          },
        ),
        onWillPop: () async {
          context.read<MainScreenProvider>().changePage(0);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MainScreen()));
          return true;
        },
      ),
    );
  }
}
