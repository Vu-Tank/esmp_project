import 'package:esmp_project/src/screens/order/Waiting_for_the_goods_screen.dart';
import 'package:esmp_project/src/screens/order/canceled_screen.dart';
import 'package:esmp_project/src/screens/order/delivered_screen.dart';
import 'package:esmp_project/src/screens/order/delivering_screen.dart';
import 'package:esmp_project/src/screens/order/received_ship_screen.dart';
import 'package:esmp_project/src/screens/order/wait_for_confirmation_screen.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';

class OrderMainScreen extends StatefulWidget {
  const OrderMainScreen({Key? key, required this.index}) : super(key: key);
  final int index;
  @override
  State<OrderMainScreen> createState() => _OrderMainScreenState();
}

class _OrderMainScreenState extends State<OrderMainScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.index,
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Đang xử lý'),
              Tab(text: 'Đã tiếp nhận'),
              Tab(text: 'Chờ lấy hàng'),
              Tab(text: 'Đang giao',),
              Tab(text: 'Đã giao',),
              Tab(text: 'Đã hủy',),
            ],
          ),
          title: const Text('Đơn hàng'),
          backgroundColor: mainColor,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            WaitingForConfirmationScreen(),
            ReceivedShipScreen(),
            WaitingForTheGoodsScreen(),
            DeliveringScreen(),
            DeliveredScreen(),
            CanceledScreen(),
          ],
        ),
      ),
    );
  }
}
