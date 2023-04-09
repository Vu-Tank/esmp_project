import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/models/data_exchange.dart';
import 'package:esmp_project/src/providers/service/data_exchange_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/screens/image_full_screen.dart';
import 'package:esmp_project/src/screens/order/add_card_screen.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataExchangeDetailScreen extends StatefulWidget {
  const DataExchangeDetailScreen({super.key, required this.exchange});
  final DataExchange exchange;

  @override
  State<DataExchangeDetailScreen> createState() =>
      _DataExchangeDetailScreenState();
}

class _DataExchangeDetailScreenState extends State<DataExchangeDetailScreen> {
  String bankName = '';
  bool isLoading = true;
  DataExchange? exchange;
  Future<void> getDataExchange() async {
    final user = context.read<UserProvider>().user;
    final dataExchangeProvider =
        Provider.of<DataExchangeProvider>(context, listen: false);

    await dataExchangeProvider
        .getDataExchangeById(
            userID: user!.userID!,
            token: user.token!,
            orderID: widget.exchange.orderID,
            serviceID: widget.exchange.afterBuyServiceID)
        .then((value) {
      if (mounted) {
        isLoading = false;
        setState(() {});
      }
    }).catchError((error) {
      showMyAlertDialog(context, error.toString());
    });
  }

  @override
  void initState() {
    getDataExchange();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dataExchangeProvider = Provider.of<DataExchangeProvider>(context);
    final exchange = dataExchangeProvider.result[0];
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Đối Soái'),
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trạng thái: ${exchange.exchangeStatus!.statusName}',
                          style: textStyleInput.copyWith(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        Row(
                          children: [
                            Text('Đơn hàng:',
                                style: textStyleInput.copyWith(fontSize: 17)),
                            const Spacer(),
                            Text(
                              exchange.orderID != null
                                  ? exchange.orderID.toString()
                                  : exchange.afterBuyServiceID.toString(),
                              style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 17),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tiền hoàn trả:',
                                  style: textStyleInput.copyWith(fontSize: 17)),
                              const SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  Utils.convertPriceVND(
                                      exchange.exchangePrice!.toDouble()),
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 20),
                                ),
                              )
                            ]),
                        const SizedBox(
                          height: 8,
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tài khoản nhận tiền: ',
                              style: TextStyle(fontSize: 17),
                            ),
                            exchange.bankName != null
                                ? Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 50),
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    child: Text(
                                        '${exchange.bankName!}-${exchange.cardNum!}',
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(fontSize: 17)))
                                : bankName != ''
                                    ? Container(
                                        decoration:
                                            BoxDecoration(border: Border.all()),
                                        constraints:
                                            const BoxConstraints(maxWidth: 100),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            bankName,
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      )
                                    : Container(),
                            if (exchange.bankName == null && bankName == '')
                              TextButton(
                                  onPressed: () async {
                                    try {
                                      bankName = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddCardScreen(
                                                    exchangeUserID: exchange
                                                        .exchangeUserID!,
                                                  )));
                                    } catch (Exception) {
                                      return;
                                    }
                                    setState(() {});
                                  },
                                  child: const Text(
                                    'Thêm >',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 17),
                                  )),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Trạng thái dòng tiền:',
                              style: TextStyle(fontSize: 17),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            exchange.image != null
                                ? InkWell(
                                    onTap: () {
                                      ImageFullScreen(url: exchange.image!);
                                    },
                                    child: SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: CachedNetworkImage(
                                        // item.itemImage,
                                        // fit: BoxFit.cover,
                                        imageUrl: exchange.image!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8.0))),
                                        ),
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  )
                                : const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Đang xử lí',
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.red),
                                    ),
                                  ),
                          ],
                        )
                      ]),
                ),
              ),
            ),
    ));
  }
}
