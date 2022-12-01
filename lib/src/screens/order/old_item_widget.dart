import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/models/order.dart';
import 'package:esmp_project/src/models/order_detail.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:flutter/material.dart';

class OldOrder extends StatelessWidget {
  const OldOrder({Key? key, required this.order, required this.status})
      : super(key: key);
  final Order order;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          child: Column(
            children: <Widget>[
              Text(
                '${order.store.storeName}-Mã đơn hàng: ${order.orderID}',
                maxLines: 1,
              ),
              const SizedBox(
                height: 8.0,
              ),
              Column(
                children: <Widget>[
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: order.details.length,
                      itemBuilder: (ctx, index) {
                        OrderDetail detail = order.details[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //hinhf anh
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: CachedNetworkImage(
                                  // item.itemImage,
                                  // fit: BoxFit.cover,
                                  imageUrl: detail.subItemImage,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
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
                              const SizedBox(
                                height: 8.0,
                              ),
                              //ten
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("${detail.subItemName}\n",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text('Số lượng: ${detail.amount}'),
                                  // tiền
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      detail.discountPurchase != 0
                                          ? Text.rich(
                                              TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                text: Utils.convertPriceVND(
                                                    detail.pricePurchase),
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                              const TextSpan(text: "-"),
                                              TextSpan(
                                                text: Utils.convertPriceVND(detail
                                                        .pricePurchase *
                                                    (1 -
                                                        detail
                                                            .discountPurchase)),
                                              ),
                                            ]))
                                          : Text(Utils.convertPriceVND(
                                              detail.pricePurchase)),
                                    ],
                                  ),
                                ],
                              )),
                            ],
                          ),
                        );
                      }),
                ],
              ),
              // số sản phẩm và thành tiền
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${order.details.length} Sản phẩm'),
                  Text(
                      'Thành tiền: ${Utils.convertPriceVND(order.getTotalPrice())}')
                ],
              )
              //trạng thái đơn hàng
            ],
          ),
        ),
      // ),
    );
  }
}
