import 'package:esmp_project/src/models/data_exchange.dart';
import 'package:esmp_project/src/models/order.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/repositoty/dataexchange_repository.dart';
import 'package:esmp_project/src/screens/order/add_card_screen.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataExchangeScreen extends StatefulWidget {
  const DataExchangeScreen({super.key, required this.order});
  final Order order;

  @override
  State<DataExchangeScreen> createState() => _DataExchangeScreenState();
}

class _DataExchangeScreenState extends State<DataExchangeScreen> {
  List<DataExchange>? dataExchange;
  @override
  void initState() {
    Order order = widget.order;
    final user = context.read<UserProvider>().user;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await DataExchangeRepository.getDataExchange(
              token: user!.token!, userID: user.userID!, orderID: order.orderID)
          .then((value) =>
              dataExchange = value.dataResponse as List<DataExchange>)
          .catchError((error) {
        showMyAlertDialog(context, error.toString());
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.payment),
              const SizedBox(
                width: 10,
              ),
              const Text('Thêm thẻ ngân hàng'),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AddCardScreen()));
                  },
                  child: const Text(
                    "Thêm",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
          Text(dataExchange.toString()),
        ],
      ),
    );
  }
}
