import 'dart:developer';

import 'package:esmp_project/src/providers/user_provider.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/address.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    List<AddressModel> list = userProvider.user!.address!;
    log(list.length.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Địa Chỉ',
          style: textStyleInput,
        ),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  log(index.toString());
                },
                child: Card(
                    child: Table(
                      children: [
                        TableRow(
                          children: [
                            Text('Tỉnh/ thành phố', style: textStyleInput,),
                            Text('${list[index].province}', style: textStyleInput,),
                          ]
                        ),
                        TableRow(
                            children: [
                              Text('Quận/ huyện', style: textStyleInput,),
                              Text('${list[index].district}', style: textStyleInput,),
                            ]
                        ),
                        TableRow(
                            children: [
                              Text('Phường/ xã', style: textStyleInput,),
                              Text('${list[index].ward}', style: textStyleInput,),
                            ]
                        ),
                      ],
                    ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){

        },
        label: Text("Thêm địa chỉ",
            style: TextStyle(color: Colors.white, fontSize: 15)),

      ),

    );
  }
}
