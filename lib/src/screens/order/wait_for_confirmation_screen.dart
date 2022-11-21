import 'dart:developer';

import 'package:esmp_project/src/providers/order/waiting_for_confirmation_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/screens/order/old_item_widget.dart';
import 'package:esmp_project/src/screens/order/order_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/widget/widget.dart';
import '../login_register/login_screen.dart';

class WaitingForConfirmationScreen extends StatefulWidget {
  const WaitingForConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<WaitingForConfirmationScreen> createState() =>
      _WaitingForConfirmationScreenState();
}

class _WaitingForConfirmationScreenState
    extends State<WaitingForConfirmationScreen> {
  final controller = ScrollController();
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    final orderProvider = Provider.of<WaitingForConfirmationProvider>(context, listen: false);
    final user = context.read<UserProvider>().user;
    if(user!=null){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        orderProvider
            .initData(userID: user.userID!, token: user.token!)
            .then((value) => _isLoading = false)
            .catchError((error) {
          showMyAlertDialog(context, error.toString());
        });
      });
    }
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        context.read<WaitingForConfirmationProvider>().addOrder().catchError((error) {
          showMyAlertDialog(context, error.toString());
        });
      }
    });
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<WaitingForConfirmationProvider>(context);
    return FutureBuilder(builder: (context, snapshot) {
      final user = context.read<UserProvider>().user;
      return Scaffold(
          body: user == null
              ? Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: const Text('Đăng nhập'),
                  ),
                )
              : _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: orderProvider.orders.length + 1,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      controller: controller,
                      itemBuilder: (context, index) {
                        if (index < orderProvider.orders.length) {
                          return InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderDetailScreen(
                                        order: orderProvider.orders[index],
                                        status: orderProvider.status.toString(),
                                      ))).then((value)async{
                                if(value!=null){
                                  if(value.toString()=='remove'){
                                    setState(() {
                                      _isLoading=true;
                                    });
                                    orderProvider.initData(userID: user!.userID!, token: user!.token!).then((value){
                                      setState(() {
                                        _isLoading=false;
                                      });
                                    }).catchError((e){
                                      showMyAlertDialog(context, e.toString());
                                    });
                                  }
                                }
                              });
                            },
                            child: OldOrder(
                              order: orderProvider.orders[index],
                              status: orderProvider.status.toString(),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: orderProvider.hasMore
                                  ? const CircularProgressIndicator()
                                  : Text(
                                      'Có ${orderProvider.orders.length} kết quả'),
                            ),
                          );
                        }
                      }));
    });
  }
}
