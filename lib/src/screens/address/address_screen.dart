import 'dart:developer';

import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/screens/address/address_detail_screen.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/address.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key, required this.status}) : super(key: key);
  final String status;
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
          style: appBarTextStyle,
        ),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if(widget.status=='select'){
                    Navigator.pop(context,list[index]);
                    return;
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AddressDetailScreen(status: 'edit', address: list[index],)));
                },
                child: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //name và tên
                          Text('${list[index].userName!} | +${list[index].userPhone}', style: textStyleInput,),
                          const SizedBox(height: 8,),
                          Text(list[index].context!, style: textStyleLabelChild,),
                          const SizedBox(height: 8,),
                          Text('${list[index].ward}, ${list[index].district}, ${list[index].province}', style: textStyleLabelChild,),
                          // Divider(color: Colors.black,),
                        ],
                      ),
                    ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddressDetailScreen(status: 'create')));
        },
        label: Text("Thêm địa chỉ",
            style: btnTextStyle),
        backgroundColor: btnColor,

      ),

    );
  }
}
