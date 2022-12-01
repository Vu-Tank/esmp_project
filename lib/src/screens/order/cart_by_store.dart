import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/models/order.dart';
import 'package:esmp_project/src/providers/cart/shopping_cart_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartByStore extends StatefulWidget {
  const CartByStore({Key? key, required this.cart, required this.index}) : super(key: key);
  final Order cart;
  final int index;
  @override
  State<CartByStore> createState() => _CartByStoreState();
}

class _CartByStoreState extends State<CartByStore> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<ShoppingCartProvider>(context);
    Order cart = widget.cart;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Radio(
                  value: widget.index,
                  groupValue: cartProvider.selectedIndex,
                  onChanged: ((value){
                    if(value!=null){
                      cartProvider.selectOrderToPay(value);
                    }
                  })),
              Text(cart.store.storeName),
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: cart.details.length,
              itemBuilder: (context, index) {
                final orderDetail = cart.details[index];
                return SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: Row(
                      children: <Widget>[
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: CachedNetworkImage(
                            // item.itemImage,
                            // fit: BoxFit.cover,
                            imageUrl: orderDetail.subItemImage,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0))),
                            ),
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(width: 8.0,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  orderDetail.subItemName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8.0,),
                              Text(
                                  Utils.convertPriceVND(orderDetail.pricePurchase*(1-orderDetail.discountPurchase)), style: TextStyle(color: Colors.red),),
                              const SizedBox(height: 8.0,),
                              // amount
                              Row(children: <Widget>[
                                IconButton(onPressed: ()async{
                                  log(orderDetail.orderDetailID.toString());
                                  // LoadingDialog.showLoadingDialog(context, "Vui lòng đợi");
                                  await cartProvider.subtractAmount(widget.index, index, context.read<UserProvider>().user!.token! , (String msg){
                                    // LoadingDialog.hideLoadingDialog(context);
                                    showMyAlertDialog(context, msg);
                                  });
                                  // if(mounted)LoadingDialog.hideLoadingDialog(context);
                                }, icon: const Icon(Icons.remove)),
                                Text('${orderDetail.amount}'),
                                IconButton(onPressed: ()async{
                                  log(orderDetail.orderDetailID.toString());
                                  // LoadingDialog.showLoadingDialog(context, "Vui lòng đợi");
                                  await cartProvider.addAmount(widget.index, index, context.read<UserProvider>().user!.token! , (String msg){
                                    // LoadingDialog.hideLoadingDialog(context);
                                    showMyAlertDialog(context, msg);
                                  });
                                  // if(mounted)LoadingDialog.hideLoadingDialog(context);
                                }, icon:const Icon(Icons.add)),
                              ],)
                            ],
                          ),
                        ),
                        IconButton(onPressed: ()async{
                          log(orderDetail.orderDetailID.toString());
                          LoadingDialog.showLoadingDialog(context, "Vui lòng đợi");
                          await cartProvider.deleteSubItem(widget.index, index, context.read<UserProvider>().user!.token! , (String msg){
                            LoadingDialog.hideLoadingDialog(context);
                            showMyAlertDialog(context, msg);
                          },(){
                            LoadingDialog.hideLoadingDialog(context);
                          });
                        }, icon:const Icon(Icons.delete, color: Colors.red,))
                      ],
                    ),
                );
              }),
        ],
      ),
    );
  }
}
