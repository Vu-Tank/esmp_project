import 'dart:developer';

import 'package:esmp_project/src/models/order.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/cart/shopping_cart_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/repositoty/order_repository.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final cartProvider = Provider.of<ShoppingCartProvider>(context, listen: false);
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
                        child: Text(snapshot.error!.toString().replaceAll('Exception:', '')),
                      );
                    } else {
                      return Consumer<ShoppingCartProvider>(
                          builder: (context, cart, __) {
                        if (cart.order!.isNotEmpty) {
                          return Scaffold(
                            body: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: cart.order?.length,
                                itemBuilder: (context, index) {
                                  return CartByStore(
                                    cart: cart.order![index],
                                    index: index,
                                  );
                                }),
                            bottomNavigationBar: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                    'Tạm tính ${(cart.selectedIndex != -1) ? Utils.convertPriceVND(cart.order![cart.selectedIndex].getPrice()) : ''}'),
                                TextButton(
                                    onPressed: (cart.selectedIndex == -1)
                                        ? null
                                        : () {
                                            log(cart.order![cart.selectedIndex].orderStatus
                                                .statusName);
                                            log(cart.order![cart.selectedIndex].orderID.toString());
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PaymentScreen(
                                                            orderID: cart.order![cart.selectedIndex].orderID)));
                                          },
                                    child: const Text('Thanh toán')),
                              ],
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text('Đăng nhập'),
              ),
            ),
    );
  }
}
