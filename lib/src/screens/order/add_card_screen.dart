import 'dart:developer';

import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/repositoty/dataexchange_repository.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key, required this.exchangeUserID});
  final int exchangeUserID;

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  String bankName = '';
  static List<String> list = listBank.toList();
  @override
  void dispose() {
    // TODO: implement dispose
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm thẻ ngân hàng'),
        centerTitle: true,
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      textField('Tên ngân hàng:', controller1),
                      textField('Tên chủ thẻ:', controller1),
                      textField('STK:', controller2),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  if (!listBank.contains(bankName) || bankName == '') {
                    showMyAlertDialog(context,
                        'Tên ngân hàng không đúng hoặc không hỗ trợ \n Vui lòng thử lại');
                  } else if (controller1.text.isEmpty ||
                      controller2.text.isEmpty) {
                    showMyAlertDialog(
                        context, 'Vui lòng điền đầy đủ thông tin');
                  } else {
                    LoadingDialog.showLoadingDialog(context, "Vui Lòng Đợi");
                    DataExchangeRepository.addCard(
                            token: user!.token!,
                            exchangeUserID: widget.exchangeUserID,
                            bankName: bankName,
                            cardNum: controller2.text,
                            cardHoldName: controller1.text)
                        .then((value) async {
                      if (value.isSuccess!) {
                        if (mounted) {
                          LoadingDialog.hideLoadingDialog(context);
                          showMyAlertDialog(context, value.message!).then((_) =>
                              Navigator.pop(
                                  context, "$bankName-${controller2.text}"));
                        }
                      } else {
                        if (mounted) {
                          LoadingDialog.hideLoadingDialog(context);
                          inspect(value);
                          showMyAlertDialog(context,
                              'Đã có lỗi! \n Vui lòng thử lại sau');
                        }
                      }
                    });
                  }
                  // if (controller1.text.isEmpty ||
                  //     controller2.text.isEmpty ||
                  //     !listBank.contains(bankName)) {
                  //   showMyAlertDialog(context, 'Vui lòng điền đầy đú');
                  // } else {
                  //   Navigator.pop(context, "$bankName-${controller2.text}");
                  // }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                ),
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget textField(String title, TextEditingController? controller) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                constraints: const BoxConstraints(minWidth: 110),
                child: Text(title)),
            title.compareTo('Tên ngân hàng:') == 0
                ? Expanded(
                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<String>.empty();
                        }
                        return list.where((String item) {
                          return item
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (option) {
                        setState(() {
                          bankName = option;
                        });
                      },
                    ),
                  ))
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        textCapitalization: TextCapitalization.characters,
                        keyboardType: title.compareTo('STK:') == 0
                            ? TextInputType.number
                            : TextInputType.text,
                        controller: controller,
                        maxLines: 1,
                        decoration: InputDecoration(
                            hintText: title.compareTo('STK:') == 0
                                ? 'Số tài khoản'
                                : 'Tên chủ thẻ',
                            border: const UnderlineInputBorder(
                                borderSide: BorderSide(width: 2))),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
