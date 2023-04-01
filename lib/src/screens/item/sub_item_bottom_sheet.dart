import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/screens/login_register/login_screen.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/sub_item.dart';
import '../../providers/cart/item_provider.dart';
import '../../utils/utils.dart';

class SubItemBottomSheet extends StatefulWidget {
  const SubItemBottomSheet({
    Key? key,
    required this.subItems,
    required this.status,
    required this.title,
  }) : super(key: key);
  final List<SubItem> subItems;
  final String status;
  final String title;

  @override
  State<SubItemBottomSheet> createState() => _SubItemBottomSheetState();
}

class _SubItemBottomSheetState extends State<SubItemBottomSheet> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ItemProvider>().initSubItem(widget.subItems[0]);
  }

  @override
  Widget build(BuildContext context) {
    final sItemProvider = Provider.of<ItemProvider>(context);
    List<SubItem> subItems = widget.subItems;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        // mainAxisSize: MainAxisSize.max,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: subItems.length,
              itemBuilder: (context, index) {
                final subItem = subItems[index];
                // log('${subItem.subItemID}-${sItemProvider.subItem!.subItemID}');
                return subItem.subItem_Status.item_StatusID == 1
                    ? GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: (subItem.subItemID ==
                                    sItemProvider.subItem!.subItemID)
                                ? btnColor
                                : Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          // color: (subItem.subItemID==sItemProvider.subItem!.subItemID)?Colors.lightBlueAccent: Colors.white,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: CachedNetworkImage(
                                  imageUrl: subItem.image.path!,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              // Image.network(subItem.image.path!),
                              Flexible(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(subItem.subItemName),
                                    Text('Kho: ${subItem.amount}'),
                                    Text(Utils.convertPriceVND(subItem.price)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          sItemProvider.selectedSubItem(subItem);
                        },
                      )
                    : const SizedBox();
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Số lượng'),
              Row(
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        sItemProvider.subtract();
                      },
                      icon: const Icon(Icons.remove)),
                  Text('${sItemProvider.amount}'),
                  IconButton(
                      onPressed: () {
                        sItemProvider.add();
                      },
                      icon: const Icon(Icons.add)),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () async {
                  UserModel? user = context.read<UserProvider>().user;
                  if (user == null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                    return;
                  }
                  LoadingDialog.showLoadingDialog(context, "Vui lòng đợi");
                  if (widget.status == 'add_cart') {
                    await sItemProvider.addToCart(
                        onSucces: (String msg) async {
                          LoadingDialog.hideLoadingDialog(context);
                          final result = await showMyAlertDialog(context, msg);
                          if (result != null) {
                            if (mounted) Navigator.pop(context);
                          }
                        },
                        onFailed: (String msg) {
                          LoadingDialog.hideLoadingDialog(context);
                          showMyAlertDialog(context, msg);
                        },
                        userID: user.userID!,
                        token: user.token!);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                ),
                child: Text(
                  widget.title,
                  style: btnTextStyle,
                )),
          ),
        ],
      ),
    );
  }
}
