import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/cubit/cubit/payment_method_cubit.dart';
import 'package:esmp_project/src/providers/cart/shopping_cart_provider.dart';
import 'package:esmp_project/src/providers/main_screen_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/screens/address/address_screen.dart';
import 'package:esmp_project/src/screens/main/main_screen.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key, required this.orderID}) : super(key: key);
  final int orderID;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentMethodCubit(),
      child: FutureBuilder(
        future: context.read<ShoppingCartProvider>().getOrderToPay(
            token: context.read<UserProvider>().user!.token!,
            orderID: widget.orderID),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            default:
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text(snapshot.error!
                        .toString()
                        .replaceAll('Exception:', '')),
                  ),
                );
              } else {
                return _paymentView(context);
              }
          }
        },
      ),
    );
  }

  _paymentView(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final orderProvider = Provider.of<ShoppingCartProvider>(context);
    inspect(orderProvider);
    log(userProvider.user!.token.toString());
    String paymentMedthod = 'MOMO';
    Future<void> _showDeleteDialog(int index, int orderDetailID) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            // <-- SEE HERE
            title: const Text('Xóa sản phẩm'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Bạn có chắc là muốn xóa sản phẩm?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Không'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  onPressed: () async {
                    await orderProvider.subtractAmountWhenPayment(
                        widget.orderID,
                        orderDetailID,
                        index,
                        context.read<UserProvider>().user!.token!,
                        (String msg) {
                      // LoadingDialog.hideLoadingDialog(context);
                      showMyAlertDialog(context, msg);
                    }).then((value) => Navigator.of(context).pop());
                  },
                  child: const Text("Chắc")),
            ],
          );
        },
      );
    }

    Future<void> _showAlertDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            // <-- SEE HERE
            title: const Text('Đặt Hàng'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Đặt hàng thành công'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    context.read<MainScreenProvider>().changePage(0);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()));
                  },
                  child: const Text("Về Trang Chủ")),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        backgroundColor: mainColor,
      ),
      body: orderProvider.selectedOrder == null
          ? Center(
              child: Column(children: [
                const Text('Không còn sản phẩm để thanh toán !!!'),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()));
                    },
                    child: const Text("Quay Lại"))
              ]),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // ddia chi
                  Card(
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddressScreen(
                                      status: 'select',
                                    ))).then((value) {
                          if (value != null) {
                            LoadingDialog.showLoadingDialog(
                                context, "Vui lòng đợi");
                            orderProvider
                                .updateSelectedOrder(
                                    value, userProvider.user!.token!)
                                .onError((error, stackTrace) =>
                                    showMyAlertDialog(
                                        context, error.toString()))
                                .then((value) {
                              LoadingDialog.hideLoadingDialog(context);
                            });
                          }
                          log(value.toString());
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.pinkAccent,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  'Địa chỉ nhận hàng',
                                  style: textStyleInputChild,
                                ),
                                Text(
                                  '${orderProvider.selectedOrder!.name} | ${orderProvider.selectedOrder!.tel}\n',
                                  style: textStyleInputChild,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                ),
                                Text(
                                  '${orderProvider.selectedOrder!.address}\n',
                                  style: textStyleInputChild,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                ),
                                Text(
                                  '${orderProvider.selectedOrder!.ward}, ${orderProvider.selectedOrder!.district}, ${orderProvider.selectedOrder!.province}\n',
                                  style: textStyleInputChild,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                )
                              ],
                            ),
                          ),
                          const Icon(Icons.navigate_next),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: [
                              const Icon(Icons.store),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                orderProvider.selectedOrder!.store.storeName,
                                style: textStyleInput,
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  orderProvider.selectedOrder!.details.length,
                              itemBuilder: (context, index) {
                                final orderDetail =
                                    orderProvider.selectedOrder!.details[index];
                                return SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: CachedNetworkImage(
                                          // item.itemImage,
                                          // fit: BoxFit.cover,
                                          imageUrl: orderDetail.subItemImage,
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
                                      const SizedBox(
                                        width: 8.0,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              orderDetail.subItemName,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: textStyleInputChild,
                                            ),
                                            const SizedBox(
                                              height: 8.0,
                                            ),
                                            Text(
                                              Utils.convertPriceVND(orderDetail
                                                      .pricePurchase *
                                                  (1 -
                                                      orderDetail
                                                          .discountPurchase)),
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 8.0,
                                            ),
                                            // amount
                                            Row(
                                              children: [
                                                Text(
                                                  'Số lượng: ',
                                                  style: textStyleInputChild,
                                                ),
                                                const Spacer(),
                                                Row(
                                                  children: [
                                                    if (orderProvider
                                                            .selectedOrder!
                                                            .orderStatus
                                                            .orderStatusID ==
                                                        7)
                                                      IconButton(
                                                          onPressed: () async {
                                                            log(orderDetail
                                                                .orderDetailID
                                                                .toString());
                                                            // LoadingDialog.showLoadingDialog(context, "Vui lòng đợi");
                                                            if (orderDetail
                                                                    .amount ==
                                                                1) {
                                                              // _showDeleteDialog(
                                                              //     index,
                                                              //     orderDetail
                                                              //         .orderDetailID);
                                                              showMyAlertDialog(
                                                                  context,
                                                                  'Không thể giảm');
                                                            } else {
                                                              await orderProvider.subtractAmountWhenPayment(
                                                                  widget
                                                                      .orderID,
                                                                  orderDetail
                                                                      .orderDetailID,
                                                                  index,
                                                                  context
                                                                      .read<
                                                                          UserProvider>()
                                                                      .user!
                                                                      .token!,
                                                                  (String msg) {
                                                                // LoadingDialog.hideLoadingDialog(context);
                                                                showMyAlertDialog(
                                                                    context,
                                                                    msg);
                                                              });
                                                            }
                                                            // if(mounted)LoadingDialog.hideLoadingDialog(context);
                                                          },
                                                          icon: const Icon(
                                                              Icons.remove)),
                                                    Text(orderDetail.amount
                                                        .toString()),
                                                    if (orderProvider
                                                            .selectedOrder!
                                                            .orderStatus
                                                            .orderStatusID ==
                                                        7)
                                                      IconButton(
                                                          onPressed: () async {
                                                            log(orderDetail
                                                                .orderDetailID
                                                                .toString());
                                                            // LoadingDialog.showLoadingDialog(context, "Vui lòng đợi");
                                                            await orderProvider
                                                                .addAmountWhenPayment(
                                                                    widget
                                                                        .orderID,
                                                                    orderDetail
                                                                        .orderDetailID,
                                                                    index,
                                                                    context
                                                                        .read<
                                                                            UserProvider>()
                                                                        .user!
                                                                        .token!,
                                                                    (String
                                                                        msg) {
                                                              // LoadingDialog.hideLoadingDialog(context);
                                                              showMyAlertDialog(
                                                                  context, msg);
                                                            });
                                                            // if(mounted)LoadingDialog.hideLoadingDialog(context);
                                                          },
                                                          icon: const Icon(
                                                              Icons.add)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                  // phương thức thánh toán
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Icon(Icons.payment),
                              Text(
                                "Phương thức thanh toán",
                                style: textStyleInputChild,
                              ),
                              const Spacer(),
                              BlocBuilder<PaymentMethodCubit,
                                  PaymentMethodState>(
                                builder: (context, state) {
                                  return Text(
                                      BlocProvider.of<PaymentMethodCubit>(
                                              context)
                                          .state
                                          .paymentMethod);
                                },
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  BlocProvider.of<PaymentMethodCubit>(context)
                                      .momoPayment();
                                  paymentMedthod =
                                      BlocProvider.of<PaymentMethodCubit>(
                                              context)
                                          .state
                                          .paymentMethod;
                                  log(paymentMedthod);
                                },
                                child: BlocBuilder<PaymentMethodCubit,
                                    PaymentMethodState>(
                                  builder: (context, state) {
                                    return Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: state.paymentMethod ==
                                                        "MOMO"
                                                    ? 2
                                                    : 1,
                                                color: state.paymentMethod ==
                                                        "MOMO"
                                                    ? Colors.black
                                                    : Colors.black12)),
                                        height: 100,
                                        width: 100,
                                        child: Image.asset(
                                            'assets/images/logo_momo.png'));
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  BlocProvider.of<PaymentMethodCubit>(context)
                                      .codPayment();
                                  paymentMedthod =
                                      BlocProvider.of<PaymentMethodCubit>(
                                              context)
                                          .state
                                          .paymentMethod;
                                  log(paymentMedthod);
                                },
                                child: BlocBuilder<PaymentMethodCubit,
                                    PaymentMethodState>(
                                  builder: (context, state) {
                                    return Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width:
                                                    state.paymentMethod == "COD"
                                                        ? 2
                                                        : 1,
                                                color:
                                                    state.paymentMethod == "COD"
                                                        ? Colors.black
                                                        : Colors.black12)),
                                        height: 100,
                                        width: 100,
                                        child: Image.asset(
                                            'assets/images/logo_cod.png'));
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    // child: Column(
                    //   children: [
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                    //         const Icon(Icons.list),
                    //         Text(
                    //           'Chi tiết thanh toán',
                    //           style: textStyleInput,
                    //         ),
                    //       ],
                    //     ),
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(
                    //           'Tiền hàng',
                    //           style: textStyleInputChild,
                    //         ),
                    //         Text(
                    //           Utils.convertPriceVND(
                    //               orderProvider.selectedOrder!.priceItem),
                    //           style: textStyleInputChild,
                    //         ),
                    //       ],
                    //     ),
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(
                    //           'Phí vận chuyển',
                    //           style: textStyleInputChild,
                    //         ),
                    //         Text(
                    //           Utils.convertPriceVND(
                    //               orderProvider.selectedOrder!.feeShip),
                    //           style: textStyleInputChild,
                    //         ),
                    //       ],
                    //     ),
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(
                    //           'Tổng thanh toán',
                    //           style: textStyleInput,
                    //         ),
                    //         Text(
                    //           Utils.convertPriceVND(
                    //               orderProvider.selectedOrder!.feeShip +
                    //                   orderProvider.selectedOrder!.priceItem),
                    //           style: TextStyle(color: Colors.red, fontSize: 18),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.list),
                            Text(
                              'Chi tiết thanh toán',
                              style: textStyleInput,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Tiền hàng',
                                    style: textStyleInputChild,
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    'Phí vận chuyển',
                                    style: textStyleInputChild,
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    'Tổng thanh toán',
                                    style: textStyleInputChild,
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      Utils.convertPriceVND(orderProvider
                                          .selectedOrder!.priceItem),
                                      style: textStyleInputChild,
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(
                                      Utils.convertPriceVND(
                                          orderProvider.selectedOrder!.feeShip),
                                      style: textStyleInputChild,
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(
                                      Utils.convertPriceVND(orderProvider
                                          .selectedOrder!
                                          .getTotalPrice()),
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
                child: Text(
              'Tổng Thanh toán: ${Utils.convertPriceVND(orderProvider.selectedOrder!.feeShip + orderProvider.selectedOrder!.priceItem)}',
              maxLines: 1,
            )),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                onPressed: () async {
                  log(orderProvider.selectedOrder!.orderID.toString());
                  String? result = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text(
                                'Bạn đã kiểm tra thông tin đơn hàng?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: Text(
                                  'Thoát',
                                  style: btnTextStyle.copyWith(color: btnColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: Text(
                                  'Xác nhận',
                                  style: btnTextStyle.copyWith(color: btnColor),
                                ),
                              ),
                            ],
                          ));
                  if (result != null) {
                    if (result == 'OK') {
                      log(paymentMedthod);
                      if (mounted) {
                        LoadingDialog.showLoadingDialog(
                            context, "Đang thanh toán");
                      }
                      await orderProvider.payment(
                          token: userProvider.user!.token!,
                          onFailed: (String msg) {
                            LoadingDialog.hideLoadingDialog(context);
                            showMyAlertDialog(context, msg);
                          },
                          onSuccess: () {
                            LoadingDialog.hideLoadingDialog(context);
                            if (paymentMedthod == "COD") {
                              _showAlertDialog();
                            }
                          },
                          paymentMethod: paymentMedthod);
                    }
                  }
                },
                child: Text(
                  'Thanh toán',
                  style: btnTextStyle,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
