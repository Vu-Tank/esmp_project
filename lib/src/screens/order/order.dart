import 'package:flutter/material.dart';

class OrderMainScreen extends StatefulWidget {
  const OrderMainScreen({Key? key}) : super(key: key);

  @override
  State<OrderMainScreen> createState() => _OrderMainScreenState();
}

class _OrderMainScreenState extends State<OrderMainScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Chờ lấy hàng'),
                Tab(text: 'Đang giao',),
                Tab(text: 'Đã giao',),
                Tab(text: 'Đã hủy',),
              ],
            ),
            title: const Text('Đơn hàng'),
            backgroundColor: Colors.pinkAccent,
          ),
          body: const TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
