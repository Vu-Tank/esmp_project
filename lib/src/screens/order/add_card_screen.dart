import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  String bankName = '';
  static List<String> list = listBank.toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Thêm thẻ ngân hàng'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            textField('Tên ngân hàng:', controller1),
            textField('Tên chủ thẻ:', controller1),
            textField('STK:', controller2),
          ],
        ),
      ),
    );
  }

  Widget textField(String title, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title),
        title.compareTo('Tên ngân hàng:') == 0
            ? Expanded(
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return list.where((String item) {
                      return item.contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (option) {
                    setState(() {
                      bankName = option;
                    });
                  },
                ),
              )
            : Expanded(
                child: TextField(
                  keyboardType: title.compareTo('STK:') == 0
                      ? TextInputType.number
                      : TextInputType.text,
                  controller: controller,
                  maxLines: 1,
                  decoration: InputDecoration(
                      hintText: title,
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2))),
                ),
              )
      ],
    );
  }
}
