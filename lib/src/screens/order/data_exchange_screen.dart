import 'package:esmp_project/src/providers/service/data_exchange_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/screens/login_register/login_screen.dart';
import 'package:esmp_project/src/screens/order/data_exchange_detail_screen.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataExchangeScreen extends StatefulWidget {
  const DataExchangeScreen({super.key});

  @override
  State<DataExchangeScreen> createState() => _DataExchangeScreenState();
}

class _DataExchangeScreenState extends State<DataExchangeScreen> {
  bool _isLoading = true;
  final controller = ScrollController();
  List<DataRow> rows = <DataRow>[];
  @override
  void initState() {
    final user = context.read<UserProvider>().user;
    final dataExchangeProvider =
        Provider.of<DataExchangeProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dataExchangeProvider
          .initData(token: user!.token!, userID: user.userID!)
          .then((value) {
        rows = dataExchangeProvider.result.map((exchange) {
          return DataRow(
            cells: [
              DataCell(Text(exchange.exchangeUserID.toString())),
              DataCell(Text(exchange.orderID != null
                  ? exchange.orderID.toString()
                  : exchange.afterBuyServiceID.toString())),
              DataCell(Text(exchange.exchangeStatus!.statusName!)),
              DataCell(onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DataExchangeDetailScreen(
                              exchange: exchange,
                            )));
              },
                  Text(
                    'Chi tiết',
                    style: TextStyle(
                        decoration: TextDecoration.underline, color: mainColor),
                  )),
            ],
          );
        }).toList();
        if (mounted) {
          _isLoading = false;
          setState(() {});
        }
      }).catchError((error) {
        showMyAlertDialog(context, error.toString());
      });
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
    final user = context.read<UserProvider>().user;
    final dataExchangeProvider = Provider.of<DataExchangeProvider>(context);
    const textSpan = TextSpan(text: 'IDMã đơnTrạng tháiChi tiết');
    final textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    final textWidth = textPainter.width;
    double size = (MediaQuery.of(context).size.width - textWidth) / 4 - 14;
    return Scaffold(
        appBar: AppBar(
          title: Text('Đối soái', style: appBarTextStyle),
          backgroundColor: mainColor,
          centerTitle: true,
        ),
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
                : Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width),
                    child: DataTable(
                        columnSpacing: size,
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Mã đơn')),
                          DataColumn(label: Text('Trạng thái')),
                          DataColumn(label: Text(''))
                        ],
                        rows: rows),
                  ));
  }
}
