import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/models/feedback.dart';
import 'package:esmp_project/src/models/order.dart';
import 'package:esmp_project/src/models/order_detail.dart';
import 'package:esmp_project/src/providers/service/service_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/screens/feedback/feedback_screen.dart';
import 'package:esmp_project/src/screens/feedback/feedback_view_screen.dart';
import 'package:esmp_project/src/screens/order/canceled_order_screen.dart';
import 'package:esmp_project/src/screens/order/return_exchange_screen.dart';
import 'package:esmp_project/src/screens/shop/shop_detail.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  int canReturn = 0;
  List<int> isReturn = <int>[];
  List<bool> _isChecked = <bool>[];
  @override
  void initState() {
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    final user = context.read<UserProvider>().user;
    if (serviceProvider.service.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        serviceProvider
            .initData(userID: user!.userID!, token: user.token!)
            .then((value) {
          while (serviceProvider.hasMore) {
            serviceProvider.addData();
          }
        });
      });
    }
    _isChecked = List<bool>.filled(widget.order.details.length, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    Order order = widget.order;
    final shipDay = DateTime.parse(
        order.orderShip!.createDate.replaceAll(RegExp(r'T'), ' '));
    final checkReturn = now.difference(shipDay).inDays;
    final serviceProvider = Provider.of<ServiceProvider>(context);
    for (var element in serviceProvider.service) {
      if (element.orderID == order.orderID) {
        if (element.details != null) {
          for (var ele in element.details!) {
            for (var detail in order.details) {
              if (ele.sub_ItemID == detail.subItemID) {
                isReturn.add(ele.sub_ItemID!);
                setState(() {});
              }
            }
          }
        }
      }
    }
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
                              style: textStyleInput.copyWith(fontSize: 15),
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
                                        builder: (context) => ShopDetailScreen(
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

                            if (checkReturn <= detail.returnAndExchange) {
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
                                                        value:
                                                            _isChecked[index],
                                                        onChanged: (value) {
                                                          if (value!) {
                                                            setState(() {
                                                              listDetail
                                                                  .add(detail);
                                                              _isChecked[
                                                                      index] =
                                                                  value;
                                                            });
                                                          }
                                                          if (!value) {
                                                            setState(() {
                                                              listDetail.remove(
                                                                  detail);
                                                              _isChecked[
                                                                      index] =
                                                                  value;
                                                            });
                                                          }
                                                          inspect(listDetail);
                                                        },
                                                      ),
                                                    )
                                                  : const SizedBox(
                                                      height: 40,
                                                    ),
                                              SizedBox(
                                                height: 70,
                                                width: 70,
                                                child: CachedNetworkImage(
                                                  // item.itemImage,
                                                  // fit: BoxFit.cover,
                                                  imageUrl: detail.subItemImage,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    8.0))),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
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
                                              Text("${detail.subItemName}\n",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis),
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
                                                  detail.discountPurchase != 0
                                                      ? Text.rich(TextSpan(
                                                          children: <TextSpan>[
                                                              TextSpan(
                                                                text: Utils
                                                                    .convertPriceVND(
                                                                        detail
                                                                            .pricePurchase),
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                ),
                                                              ),
                                                              const TextSpan(
                                                                  text: "-"),
                                                              TextSpan(
                                                                text: Utils.convertPriceVND(detail
                                                                        .pricePurchase *
                                                                    (1 -
                                                                        detail
                                                                            .discountPurchase)),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            ]))
                                                      : Text(
                                                          Utils.convertPriceVND(
                                                              detail
                                                                  .pricePurchase),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .red),
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
                                                                              detail.orderDetailID))).then(
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
                                                                  builder:
                                                                      (context) =>
                                                                          FeedbackViewScreen(
                                                                            feedbackModel:
                                                                                FeedbackModel(
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
                                                  ],
                                                )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                                isReturn.contains(detail.subItemID) &&
                                        widget.status == '5'
                                    ? ConstrainedBox(
                                        constraints: const BoxConstraints(
                                            minWidth: 360,
                                            minHeight: 0,
                                            maxHeight: 165),
                                        child: Container(
                                          color: Colors.black.withOpacity(0.5),
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
                                    : const SizedBox()
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
                                                    orderDetail: listDetail,
                                                    order: order,
                                                  )));
                                },
                                child: const Text('Trả hàng/Hoàn tiền')),
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
