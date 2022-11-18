import 'dart:developer';

import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/providers/order/old_order_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/repositoty/order_repository.dart';
import 'package:esmp_project/src/screens/order/order.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CanceledOrderScreen extends StatefulWidget {
  const CanceledOrderScreen({Key? key, required this.orderID})
      : super(key: key);
  final int orderID;

  @override
  State<CanceledOrderScreen> createState() => _CanceledOrderScreenState();
}

class _CanceledOrderScreenState extends State<CanceledOrderScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _selectionReason = [
    'Muốn thay đổi địa chỉ giao hàng',
    'Muốn thay đổi sản phẩm trong đơn hàng( size, màu sắc, số lương...)',
    'Tìm thấy giá rẻ hơn chỗ khác',
    'Đổi ý, không muốn mua nữa',
  ];

  String _value = 'Muốn thay đổi địa chỉ giao hàng';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Huỷ Hoá đơn ${widget.orderID}',
          style: appBarTextStyle,
        ),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              itemCount: _selectionReason.length,
              controller: ScrollController(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) =>
                  Container(
                    height: 50,
                    color: Colors.white,
                    child: RadioListTile(title: Text(_selectionReason[index]),
                      value: _selectionReason[index],
                      groupValue: _value,
                      onChanged: (value) {
                        if (value != null) {
                          log(value);
                          setState(() {
                            _value = value;
                          });
                        }
                      },
                    ),
                  ),
            ),
            const SizedBox(height: 10.0,),
            SizedBox(
              width: double.infinity,
              height: 53,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor,
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  onPressed: () async {
                    LoadingDialog.showLoadingDialog(context, 'Vui lòng đợi');
                    await context.read<OldOrderProvider>().cancelOrder(
                        orderID: widget.orderID,
                        reason: _value,
                        token: context
                            .read<UserProvider>()
                            .user!
                            .token!,
                        onSuccess: (){
                          LoadingDialog.hideLoadingDialog(context);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const OrderMainScreen(index: 0)));
                        },
                        onFailed: (String msg){
                          LoadingDialog.hideLoadingDialog(context);
                          showMyAlertDialog(context, msg);
                        });
                  },
                  child: Text(
                    'Huỷ đơn hàng',
                    style: btnTextStyle,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
