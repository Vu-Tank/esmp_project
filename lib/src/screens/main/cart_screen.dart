import 'dart:developer';

import 'package:esmp_project/src/providers/cart/shopping_cart_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/screens/login_register/login_screen.dart';
import 'package:esmp_project/src/screens/order/cart_by_store.dart';
import 'package:esmp_project/src/screens/order/payment_screen.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // bool isCheck = false;
  Future<void> _showAlertDialog(int orderId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: Center(
            child: Text(
              'Thông báo',
              style: textStyleInput.copyWith(color: mainColor),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Cửa hàng khác nhau thì phí dịch vụ cũng sẽ khác nhau!!',
                  style: textStyleInput,
                ),
              ],
            ),
          ),

          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Hủy")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PaymentScreen(orderID: orderId)));
                },
                child: const Text("OK")),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final cartProvider =
        Provider.of<ShoppingCartProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Giỏ hàng')),
        automaticallyImplyLeading: false,
        backgroundColor: mainColor,
      ),
      body: context.read<UserProvider>().user != null
          ? FutureBuilder(
              future: cartProvider.loadData(
                  userId: userProvider.user!.userID!,
                  token: userProvider.user!.token!),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error!
                            .toString()
                            .replaceAll('Exception:', '')),
                      );
                    } else {
                      return Consumer<ShoppingCartProvider>(
                          builder: (context, cart, __) {
                        if (cart.order!.isNotEmpty) {
                          return Scaffold(
                            body: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (cart.order!.isNotEmpty)
                                  Container(
                                    color: Colors.amber[50],
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Chọn đơn hàng để thanh toán!!',
                                        style: textStyleInputChild,
                                      ),
                                    ),
                                  ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: cart.order?.length,
                                    itemBuilder: (context, index) {
                                      return CartByStore(
                                        cart: cart.order![index],
                                        index: index,
                                      );
                                    }),
                              ],
                            ),
                            bottomNavigationBar: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                          'Tạm tính ${(cart.selectedIndex != -1) ? Utils.convertPriceVND(cart.order![cart.selectedIndex].getPrice()) : ''}'),
                                    ),
                                    TextButton(
                                        onPressed: (cart.selectedIndex == -1)
                                            ? null
                                            : () {
                                                log(cart
                                                    .order![cart.selectedIndex]
                                                    .orderStatus
                                                    .statusName);
                                                log(cart
                                                    .order![cart.selectedIndex]
                                                    .orderID
                                                    .toString());
                                                _showAlertDialog(cart
                                                    .order![cart.selectedIndex]
                                                    .orderID);
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             PaymentScreen(
                                                //                 orderID: cart
                                                //                     .order![cart
                                                //                         .selectedIndex]
                                                //                     .orderID)));
                                              },
                                        child: Text(
                                          'Thanh toán',
                                          style: TextStyle(
                                              color:
                                                  (cartProvider.selectedIndex !=
                                                          -1)
                                                      ? btnColor
                                                      : Colors.grey),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Center(
                            child: Text(
                              'Chưa có sản phẩm nào trong giỏ hàng',
                              style: textStyleInput,
                            ),
                          );
                        }
                      });
                    }
                }
              })
          : Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: Text(
                  'Đăng nhập',
                  style: btnTextStyle.copyWith(color: btnColor),
                ),
              ),
            ),
    );
  }
}
