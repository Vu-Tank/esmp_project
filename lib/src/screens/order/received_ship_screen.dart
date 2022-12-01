
import 'package:esmp_project/src/providers/order/received_ship_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/screens/login_register/login_screen.dart';
import 'package:esmp_project/src/screens/order/old_item_widget.dart';
import 'package:esmp_project/src/screens/order/order_detail_screen.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceivedShipScreen extends StatefulWidget {
  const ReceivedShipScreen({Key? key}) : super(key: key);

  @override
  State<ReceivedShipScreen> createState() => _ReceivedShipScreenState();
}

class _ReceivedShipScreenState extends State<ReceivedShipScreen> {
  final controller = ScrollController();
  late bool _isLoading;
  @override
  void initState() {
    // TODO: implement initState
    final orderProvider = Provider.of<ReceivedShipProvider>(context, listen: false);
    final user = context.read<UserProvider>().user;
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderProvider
          .initData(userID: user!.userID!, token: user.token!)
          .then((value) => _isLoading = false)
          .catchError((error) {
        showMyAlertDialog(context, error.toString());
      });
    });
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        context.read<ReceivedShipProvider>().addOrder().catchError((error) {
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
    final orderProvider = Provider.of<ReceivedShipProvider>(context);
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
