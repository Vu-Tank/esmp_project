import 'dart:async';
import 'dart:developer';

import 'package:esmp_project/src/cubit/check_pay/check_pay_cubit.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../providers/main_screen_provider.dart';
import '../../providers/user/user_provider.dart';
import '../../utils/widget/widget.dart';
import '../main/main_screen.dart';

class WaitingCallbackMomo extends StatefulWidget {
  const WaitingCallbackMomo({Key? key, required this.queryParams})
      : super(key: key);

  final Map queryParams;

  @override
  State<WaitingCallbackMomo> createState() => _WaitingCallbackMomoState();
}

class _WaitingCallbackMomoState extends State<WaitingCallbackMomo> {
  late Timer _timer;
  late UserModel? userModel;
  @override
  void initState() {
    super.initState();
    userModel = context.read<UserProvider>().user;
    if (userModel == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainScreen()));
    }
    _timer = Timer(const Duration(seconds: 0), () {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MainScreen()));
          return true;
        },
        child: BlocProvider(
          create: (context) => CheckPayCubit()
            ..checkPay(
                orderID: widget.queryParams['orderID'],
                token: context.read<UserProvider>().user!.token!),
          child: BlocConsumer<CheckPayCubit, CheckPayState>(
            listener: (context, state) async {
              log(state.toString());
              if (state is CheckPaying) {
                _timer = Timer(const Duration(seconds: 2), () {
                  context.read<CheckPayCubit>().checkPay(
                      orderID: widget.queryParams['orderID'],
                      token: context.read<UserProvider>().user!.token!);
                });
                // await Future.delayed(const Duration(seconds: 2)).whenComplete(() {
                //   context.read<CheckPayCubit>().checkPay(
                //       orderID: widget.queryParams['orderID'],
                //       token: context.read<UserProvider>().user!.token!);
                //   log("check");
                // });
              }
            },
            builder: (context, state) {
              if (state is CheckPayErorr) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.msg,
                        style: textStyleError,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      SizedBox(
                        height: 54.0,
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<CheckPayCubit>().checkPay(
                                orderID: widget.queryParams['orderID'],
                                token:
                                    context.read<UserProvider>().user!.token!);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: btnColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ),
                          child: Text(
                            'Thử lại',
                            style: btnTextStyle,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else if (state is CheckPaySuccess) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Expanded(
                        child: Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 200,
                        ),
                      ),
                      const Text(
                        'Thanh toán thành công',
                        style: TextStyle(color: Colors.green, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 53,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<MainScreenProvider>().changePage(0);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: btnColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ),
                          child: Text("Về màn hình chính",
                              style: btnTextStyle),
                        ),
                      )
                    ],
                  ),
                );
              } else if (state is CheckPayFailed) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Expanded(
                        child: Icon(
                          Icons.error_outline_outlined,
                          color: Colors.red,
                          size: 200,
                        ),
                      ),
                      const Text(
                        "Thanh toán thất bại",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 53,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<MainScreenProvider>().changePage(0);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: btnColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ),
                          child: Text("Về màn hình chính",
                              style: btnTextStyle),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Đang tiến hành thanh toán',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
