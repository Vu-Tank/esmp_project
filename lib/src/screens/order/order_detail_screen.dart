import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/models/order_ship.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:esmp_project/src/models/feedback.dart';
import 'package:esmp_project/src/models/order.dart';
import 'package:esmp_project/src/models/order_detail.dart';
import 'package:esmp_project/src/providers/service/service_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/repositoty/order_repository.dart';
import 'package:esmp_project/src/screens/feedback/feedback_screen.dart';
import 'package:esmp_project/src/screens/feedback/feedback_view_screen.dart';
import 'package:esmp_project/src/screens/order/canceled_order_screen.dart';
import 'package:esmp_project/src/screens/order/payment_screen.dart';
import 'package:esmp_project/src/screens/order/return_exchange_screen.dart';
import 'package:esmp_project/src/screens/shop/shop_detail.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({Key? key, required this.order, required this.status})
      : super(key: key);
  final Order order;
  final String status;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List<OrderDetail> listDetail = <OrderDetail>[];
  late ListShip listShip;
  int canReturn = 0;
  List<int> isReturn = <int>[];
  List<bool> _isChecked = <bool>[];
  final List<bool> _isReturn = <bool>[];
  bool isInit = true;
  bool isLoading = true;
  Future<void> initData() async {
    Order order = widget.order;

    final user = context.read<UserProvider>().user;
    await OrderRepository.getOrderShip(
            orderID: order.orderID, token: user!.token!)
        .then((value) {
      listShip = value.dataResponse;
    });
    await Provider.of<ServiceProvider>(context, listen: false)
        .getServiceByOrder(
            userID: user.userID!, token: user.token!, orderID: order.orderID)
        .then((value) {
      final serviceProvider =
          Provider.of<ServiceProvider>(context, listen: false);
      if (serviceProvider.service.isNotEmpty) {
        if (serviceProvider.service[0].details != null) {
          for (var element in serviceProvider.service[0].details!) {
            isReturn = List<int>.filled(
                serviceProvider.service[0].details!.length,
                element.sub_ItemID!);
          }

          for (int j = 0; j < widget.order.details.length; j++) {
            if (isReturn.contains(widget.order.details[j].subItemID)) {
              _isReturn.add(true);
            } else {
              _isReturn.add(false);
            }
          }
        }
      }

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  getListShip(ListShip list) {
    List<Widget> listShip = [];
    for (int i = list.orderShip!.length - 1; i >= 0; i--) {
      listShip.add(TimelineTile(
        alignment: TimelineAlign.start,
        isFirst: i == list.orderShip!.length - 1,
        isLast: i == 0,
        endChild: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list.orderShip![i].status!,
                    style: TextStyle(
                        color: i != list.orderShip!.length - 1
                            ? Colors.grey
                            : Colors.black),
                  ),
                  Text(
                    list.orderShip![i].create_Date!
                        .replaceAll('T', ' ')
                        .toString()
                        .split('.')[0],
                    style: TextStyle(
                        color: i != list.orderShip!.length - 1
                            ? Colors.grey
                            : Colors.black),
                  )
                ],
              )),
        ),
        indicatorStyle: const IndicatorStyle(
          width: 20,
          height: 20,
          padding: EdgeInsets.all(8),
          indicator: Icon(Icons.circle),
        ),
      ));
    }
    return listShip;
  }

  @override
  void initState() {
    Order order = widget.order;

    // final user = context.read<UserProvider>().user;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<ServiceProvider>(context, listen: false).getServiceByOrder(
    //       userID: user!.userID!, token: user.token!, orderID: order.orderID);
    // });
    if (isInit) {
      isInit = false;
      initData();
    }
    isInit = false;
    _isChecked = List<bool>.filled(order.details.length, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final user = context.read<UserProvider>().user;
    Order order = widget.order;
    final shipDay = DateTime.parse(
        order.orderShip!.createDate.replaceAll(RegExp(r'T'), ' '));
    final checkReturn = now.difference(shipDay).inDays;

    Widget? bottomNavigationBar(String status) {
      switch (status) {
        case "1":
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnColor,
                  padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CanceledOrderScreen(
                                orderID: order.orderID,
                              )));
                },
                child: Text(
                  'Huỷ đơn hàng',
                  style: btnTextStyle,
                )),
          );
        case "5":
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnColor,
                  padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                ),
                onPressed: () async {
                  await OrderRepository.getReOrder(
                          orderID: order.orderID, token: user!.token!)
                      .then((value) {
                    Order orderNew = value.dataResponse as Order;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                                  orderID: orderNew.orderID,
                                )));
                  });
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => PaymentScreen(

                  //             )));
                },
                child: Text(
                  'Mua lại',
                  style: btnTextStyle,
                )),
          );
        default:
          return null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin đơn hàng', style: appBarTextStyle),
        backgroundColor: mainColor,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // trạng thái đơn
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trạng thái: ${order.orderShip!.status}',
                              style: textStyleInput.copyWith(fontSize: 15),
                            ),
                            if (widget.status == '-1')
                              Text(
                                'Nguyên nhân: ${order.reason}',
                                style: textStyleInput,
                              ),
                            if (widget.status == '-1')
                              Text(
                                'Thời gian: ${order.pickTime}',
                                style: textStyleInput,
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // địa chỉ nhận
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const Icon(Icons.location_on_outlined),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Địa chỉ nhận hàng',
                                    style:
                                        textStyleInput.copyWith(fontSize: 15),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${order.name}\n',
                                    maxLines: 1,
                                    style: textStyleInputChild,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '+${order.tel}\n',
                                    maxLines: 1,
                                    style: textStyleInputChild,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${order.address}, ${order.ward}, ${order.district}, ${order.province} \n\n\n',
                                    maxLines: 3,
                                    style: textStyleInputChild,
                                    overflow: TextOverflow.fade,
                                  )
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //thoong tin shop va san pham
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                  '${order.store.storeName}\n',
                                  maxLines: 1,
                                  style: textStyleInput.copyWith(fontSize: 18),
                                )),
                                OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ShopDetailScreen(
                                                      store: order.store)));
                                    },
                                    child: Text(
                                      'Xem shop',
                                      style: textStyleInput.copyWith(
                                          color: mainColor, fontSize: 18),
                                    ))
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            // pproduct
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: order.details.length,
                                itemBuilder: (ctx, index) {
                                  OrderDetail detail = order.details[index];
                                  if (detail.returnAndExchange == 0) {
                                    canReturn = 0;
                                  } else if (checkReturn <
                                      detail.returnAndExchange) {
                                    canReturn++;
                                  } else {
                                    canReturn = 0;
                                  }

                                  return Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                //hinhf anh
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    widget.status == '5' &&
                                                            checkReturn <=
                                                                detail
                                                                    .returnAndExchange
                                                        ? Transform.scale(
                                                            scale: 0.7,
                                                            // child: NewCheckBox(
                                                            //   key: UniqueKey(),
                                                            //   isChecked: isChecked,
                                                            //   callBackfunction: callback,
                                                            // ),
                                                            child: Checkbox(
                                                              key: UniqueKey(),
                                                              value: _isChecked[
                                                                  index],
                                                              onChanged:
                                                                  (value) {
                                                                if (value!) {
                                                                  setState(() {
                                                                    listDetail.add(
                                                                        detail);
                                                                    _isChecked[
                                                                            index] =
                                                                        value;
                                                                  });
                                                                }
                                                                if (!value) {
                                                                  setState(() {
                                                                    listDetail
                                                                        .remove(
                                                                            detail);
                                                                    _isChecked[
                                                                            index] =
                                                                        value;
                                                                  });
                                                                }
                                                                inspect(
                                                                    listDetail);
                                                              },
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                    SizedBox(
                                                      height: 70,
                                                      width: 70,
                                                      child: CachedNetworkImage(
                                                        // item.itemImage,
                                                        // fit: BoxFit.cover,
                                                        imageUrl:
                                                            detail.subItemImage,
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          8.0))),
                                                        ),
                                                        placeholder:
                                                            (context, url) =>
                                                                const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                //ten
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                        "${detail.subItemName}\n",
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                    const SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Text(
                                                        'Số lượng: ${detail.amount}'),

                                                    // tiền
                                                    const SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        detail.discountPurchase !=
                                                                0
                                                            ? Text.rich(TextSpan(
                                                                children: <
                                                                    TextSpan>[
                                                                    TextSpan(
                                                                      text: Utils.convertPriceVND(
                                                                          detail
                                                                              .pricePurchase),
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        decoration:
                                                                            TextDecoration.lineThrough,
                                                                      ),
                                                                    ),
                                                                    const TextSpan(
                                                                        text:
                                                                            "-"),
                                                                    TextSpan(
                                                                      text: Utils.convertPriceVND(detail
                                                                              .pricePurchase *
                                                                          (1 -
                                                                              detail.discountPurchase)),
                                                                      style: const TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  ]))
                                                            : Text(
                                                                Utils.convertPriceVND(
                                                                    detail
                                                                        .pricePurchase),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                      ],
                                                    ),
                                                    if (widget.status == '5')
                                                      (detail.feedBackDate ==
                                                              null)
                                                          ? OutlinedButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                FeedbackScreen(orderDetailID: detail.orderDetailID))).then(
                                                                    (value) {
                                                                  if (value !=
                                                                      null) {
                                                                    FeedbackModel
                                                                        feedbackModel =
                                                                        value
                                                                            as FeedbackModel;
                                                                    setState(
                                                                        () {
                                                                      detail.feedbackTitle =
                                                                          feedbackModel
                                                                              .comment;
                                                                      detail.listImageFb =
                                                                          feedbackModel
                                                                              .imagesFB;
                                                                      detail.feedbackRate =
                                                                          feedbackModel
                                                                              .rate;
                                                                      detail.feedBackDate =
                                                                          feedbackModel
                                                                              .createDate;
                                                                    });
                                                                  }
                                                                });
                                                              },
                                                              child: Text(
                                                                'Đánh giá',
                                                                style: TextStyle(
                                                                    color:
                                                                        mainColor),
                                                              ))
                                                          : OutlinedButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            FeedbackViewScreen(
                                                                              feedbackModel: FeedbackModel(
                                                                                orderDetaiID: detail.orderDetailID,
                                                                                subItemName: detail.subItemName,
                                                                                subItemImage: detail.subItemImage,
                                                                                rate: detail.feedbackRate,
                                                                                createDate: detail.feedBackDate,
                                                                                comment: detail.feedbackTitle,
                                                                                imagesFB: detail.listImageFb,
                                                                              ),
                                                                            )));
                                                              },
                                                              child: Text(
                                                                'Xem đánh giá',
                                                                style: TextStyle(
                                                                    color:
                                                                        mainColor),
                                                              )),
                                                  ],
                                                )),
                                              ],
                                            ),
                                            widget.status == '5'
                                                ? detail.returnAndExchange == 0
                                                    ? const Text(
                                                        'Sản phẩm không được đổi trả')
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              'Đổi trả trong ${detail.returnAndExchange} ngày'),
                                                        ],
                                                      )
                                                : const SizedBox()
                                          ],
                                        ),
                                      ),
                                      // ignore: prefer_contains
                                      if (_isReturn.isNotEmpty
                                          ? _isReturn[index]
                                          : false)
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              minWidth: 360,
                                              minHeight: 0,
                                              maxHeight: 165),
                                          child: Container(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            child: const Center(
                                                child: Text(
                                              'Sản phẩm đang đổi trả',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        )
                                    ],
                                  );
                                }),
                            if (widget.status == '5')
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: btnColor),
                                      onPressed: () {
                                        listDetail.isEmpty
                                            ? showMyAlertDialog(context,
                                                'Chọn sản phẩm để đổi trả')
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReturnAndExchangeScreen(
                                                          orderDetail:
                                                              listDetail,
                                                          order: order,
                                                        )));
                                      },
                                      child:
                                          const Text('Trả hàng/Hoàn tiền')),
                                ],
                              )
                            else
                              const SizedBox(),
                            const Divider(
                              color: Colors.black,
                            ),
                            // phi ship
                            // Text(
                            //     'Tiền hàng: ${Utils.convertPriceVND(order.priceItem)}'),
                            // Text(
                            //     'Phí vận chuyển: ${Utils.convertPriceVND(order.feeShip)}'),
                            // Text(
                            //   'Thành tiền: ${Utils.convertPriceVND(order.priceItem + order.feeShip)}',
                            //   style: const TextStyle(color: Colors.red),
                            // ),
                            Text(
                              'Chi phí',
                              style: textStyleInput,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Stack(
                              children: <Widget>[
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Tiền hàng',
                                        style: textStyleLabelChild,
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        'Phí vận chuyển',
                                        style: textStyleLabelChild,
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        'Thành tiền',
                                        style: textStyleInputChild,
                                      ),
                                    ],
                                  ),
                                ),
                                // const SizedBox(width: 50,),
                                Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          Utils.convertPriceVND(
                                              order.priceItem),
                                          style: textStyleInputChild,
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          Utils.convertPriceVND(order.feeShip),
                                          style: textStyleInputChild,
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          Utils.convertPriceVND(
                                              order.priceItem + order.feeShip),
                                          style: textStyleError,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Mã đơn hàng',
                                    style: textStyleLabelChild.copyWith(
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    'Mã giao hàng\n',
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    style: textStyleLabelChild.copyWith(
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    'Thời gian thanh toán',
                                    style: textStyleLabelChild,
                                  )
                                ],
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    order.orderID.toString(),
                                    style: textStyleLabelChild.copyWith(
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  GestureDetector(
                                    onLongPress: () {
                                      Clipboard.setData(ClipboardData(
                                              text: order.orderShip!.labelID))
                                          .then((result) {
                                        const snackBar = SnackBar(
                                          content: Text('Copied to Clipboard'),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      });
                                    },
                                    child: Container(
                                      constraints:
                                          const BoxConstraints(maxWidth: 200),
                                      child: Text(
                                        '${order.orderShip!.labelID.toString()}\n',
                                        style: textStyleLabelChild.copyWith(
                                            color: Colors.black),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    order.createDate
                                        .replaceAll('T', ' ')
                                        .toString()
                                        .split('.')[0],
                                    style: textStyleLabelChild,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: getListShip(listShip),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
      bottomNavigationBar:
          isLoading ? null : bottomNavigationBar(widget.status),
    );
  }
}
