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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        child: FutureBuilder(
          future: PaymentRepository.checkPaymentOrder(
              orderID: widget.queryParams['orderID'],
              token: context.read<UserProvider>().user!.token!),
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
                          Text(
                            snapshot.data!.message!,
                            style: const TextStyle(
                                color: Colors.green, fontSize: 20),
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          SizedBox(
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
                          Text(
                            snapshot.data!.message!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 20),
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          SizedBox(
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
                  }
                }
            }
          },
        ),
        onWillPop: ()async{
          context.read<MainScreenProvider>().changePage(0);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MainScreen()));
          return true;
        },
      ),
    );
  }
}
