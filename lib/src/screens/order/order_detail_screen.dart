import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/models/feedback.dart';
import 'package:esmp_project/src/models/order.dart';
import 'package:esmp_project/src/models/order_detail.dart';
import 'package:esmp_project/src/screens/feedback/feedback_screen.dart';
import 'package:esmp_project/src/screens/feedback/feedback_view_screen.dart';
import 'package:esmp_project/src/screens/order/canceled_order_screen.dart';
import 'package:esmp_project/src/screens/order/return_exchange_screen.dart';
import 'package:esmp_project/src/screens/shop/shop_detail.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({Key? key, required this.order, required this.status})
      : super(key: key);
  final Order order;
  final String status;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool isChecked = false;
  List<OrderDetail> listDetail = <OrderDetail>[];
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    Order order = widget.order;
    final shipDay = DateTime.parse(
        order.orderShip!.createDate.replaceAll(RegExp(r'T'), ' '));
    final checkReturn = now.difference(shipDay).inDays;
    Widget? bottomNavigationBar(String status) {
      switch (status) {
        case "1":
          return ElevatedButton(
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
              ));
        case "5":
          // return ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: btnColor,
          //       padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
          //       shape: const RoundedRectangleBorder(
          //           borderRadius: BorderRadius.all(Radius.circular(8))),
          //     ),
          //     onPressed: () async {
          //       // Navigator.push(
          //       //     context,
          //       //     MaterialPageRoute(
          //       //         builder: (context) => CanceledOrderScreen(
          //       //               orderID: order.orderID,
          //       //             )));
          //     },
          //     child: Text(
          //       'Yêu cầu hoàn tiền/ Trả hàng',
          //       style: btnTextStyle,
          //     ));
          break;
        default:
          return null;
      }
      return null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin đơn hàng', style: appBarTextStyle),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
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
                        style: textStyleInput,
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
                              style: textStyleInput,
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
                            style: textStyleInput,
                          )),
                          OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShopDetailScreen(
                                            store: order.store)));
                              },
                              child: Text(
                                'Xem shop',
                                style:
                                    textStyleInput.copyWith(color: mainColor),
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
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      //hinhf anh
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          widget.status == '5'
                                              ? Checkbox(
                                                  value: isChecked,
                                                  onChanged: (value) {
                                                    if (value!) {
                                                      setState(() {
                                                        listDetail.add(detail);
                                                        isChecked = value;
                                                      });
                                                    }
                                                    if (!value) {
                                                      setState(() {
                                                        listDetail
                                                            .remove(detail);
                                                        isChecked = value;
                                                      });
                                                    }
                                                    log(isChecked.toString());
                                                    inspect(listDetail);
                                                  },
                                                )
                                              : const SizedBox(),
                                          SizedBox(
                                            height: 130,
                                            width: 130,
                                            child: CachedNetworkImage(
                                              // item.itemImage,
                                              // fit: BoxFit.cover,
                                              imageUrl: detail.subItemImage,
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
                                                            Radius.circular(
                                                                8.0))),
                                              ),
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ],
                                      ),
                                      //ten
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text("${detail.subItemName}\n",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text('Số lượng: ${detail.amount}'),
                                          Text(
                                              'Doi tra: ${detail.returnAndExchange}'),
                                          // tiền
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              detail.discountPurchase != 0
                                                  ? Text.rich(
                                                      TextSpan(children: <
                                                          TextSpan>[
                                                      TextSpan(
                                                        text: Utils
                                                            .convertPriceVND(detail
                                                                .pricePurchase),
                                                        style: const TextStyle(
                                                          color: Colors.grey,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                        ),
                                                      ),
                                                      const TextSpan(text: "-"),
                                                      TextSpan(
                                                        text: Utils.convertPriceVND(
                                                            detail.pricePurchase *
                                                                (1 -
                                                                    detail
                                                                        .discountPurchase)),
                                                        style: const TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ]))
                                                  : Text(
                                                      Utils.convertPriceVND(
                                                          detail.pricePurchase),
                                                      style: const TextStyle(
                                                          color: Colors.red),
                                                    ),
                                            ],
                                          ),
                                          if (widget.status == '5')
                                            (detail.feedBackDate == null)
                                                ? OutlinedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FeedbackScreen(
                                                                      orderDetailID:
                                                                          detail
                                                                              .orderDetailID))).then(
                                                          (value) {
                                                        if (value != null) {
                                                          FeedbackModel
                                                              feedbackModel =
                                                              value
                                                                  as FeedbackModel;
                                                          setState(() {
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
                                                          color: mainColor),
                                                    ))
                                                : OutlinedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FeedbackViewScreen(
                                                                    feedbackModel:
                                                                        FeedbackModel(
                                                                      orderDetaiID:
                                                                          detail
                                                                              .orderDetailID,
                                                                      subItemName:
                                                                          detail
                                                                              .subItemName,
                                                                      subItemImage:
                                                                          detail
                                                                              .subItemImage,
                                                                      rate: detail
                                                                          .feedbackRate,
                                                                      createDate:
                                                                          detail
                                                                              .feedBackDate,
                                                                      comment:
                                                                          detail
                                                                              .feedbackTitle,
                                                                      imagesFB:
                                                                          detail
                                                                              .listImageFb,
                                                                    ),
                                                                  )));
                                                    },
                                                    child: Text(
                                                      'Xem đánh giá',
                                                      style: TextStyle(
                                                          color: mainColor),
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
                                                checkReturn <=
                                                        detail.returnAndExchange
                                                    ? ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    btnColor),
                                                        onPressed: () {
                                                          listDetail.isEmpty
                                                              ? showMyAlertDialog(
                                                                  context,
                                                                  'Chọn sản phẩm để đổi trả')
                                                              : Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ReturnAndExchangeScreen(
                                                                            orderDetail:
                                                                                listDetail,
                                                                            order:
                                                                                order,
                                                                          )));
                                                        },
                                                        child: const Text(
                                                            'Trả hàng/Hoàn tiền'))
                                                    : const Spacer()
                                              ],
                                            )
                                      : const SizedBox()
                                ],
                              ),
                            );
                          }),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    Utils.convertPriceVND(order.priceItem),
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
                  child: Stack(
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
                            Text(
                              '${order.orderShip!.labelID.toString()}\n',
                              style: textStyleLabelChild.copyWith(
                                  color: Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(widget.status),
    );
  }
}
