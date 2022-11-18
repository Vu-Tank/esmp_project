import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/item.dart';
import 'package:esmp_project/src/repositoty/item_repository.dart';
import 'package:esmp_project/src/screens/item/item_detail_screen.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 9,
              child: CachedNetworkImage(
                // item.itemImage,
                // fit: BoxFit.cover,
                imageUrl: item.itemImage,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator(),),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  //ten
                  Text(
                    "${item.name} \n\n\n",
                    style: textStyleInputChild,
                    maxLines: 3,
                    overflow: TextOverflow.fade,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text.rich(TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: (item.discount!=0)?Utils.convertPriceVND(item.price):'',
                          style: const TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const TextSpan(text: "\n"),
                        TextSpan(
                            text: Utils.convertPriceVND(item.price*(1-item.discount)),
                            style: textStyleError
                        ),
                      ]
                  )),
                  const SizedBox(
                    height: 8.0,
                  ),
                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.star,
                            color: Colors.yellowAccent,
                          ),
                          Text(item.rate.toString()),
                        ],
                      ),
                      Text('Đã bán: ${item.numSold}', maxLines: 1, overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  //tỉnh
                  Text(
                    item.province,
                    style: textStyleLabelChild,
                  ),
                ],
              ),
            ),
          ],
        ),
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: <Widget>[
        //     AspectRatio(
        //       aspectRatio: 18 / 9,
        //       child: CachedNetworkImage(
        //         // item.itemImage,
        //         // fit: BoxFit.cover,
        //         imageUrl: item.itemImage,
        //         imageBuilder: (context, imageProvider) => Container(
        //           decoration: BoxDecoration(
        //             image: DecorationImage(
        //               image: imageProvider,
        //               fit: BoxFit.cover,
        //             ),
        //           ),
        //         ),
        //         placeholder: (context, url) =>
        //             const Center(child: CircularProgressIndicator(),),
        //         errorWidget: (context, url, error) => const Icon(Icons.error),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: <Widget>[
        //           //ten
        //           Text(
        //             item.name,
        //             style: textStyleInputChild,
        //             maxLines: 3,
        //             overflow: TextOverflow.ellipsis,
        //           ),
        //           const SizedBox(
        //             height: 8.0,
        //           ),
        //           (item.discount==0)
        //           //gia
        //           ?Text(
        //             Utils.convertPriceVND(item.price),
        //             style: textStyleError,
        //           )
        //           :Text.rich(TextSpan(
        //               children: <TextSpan>[
        //                 TextSpan(
        //                   text: Utils.convertPriceVND(item.price),
        //                   style: const TextStyle(
        //                     color: Colors.grey,
        //                     decoration: TextDecoration.lineThrough,
        //                   ),
        //                 ),
        //                 const TextSpan(text: "\n"),
        //                 TextSpan(
        //                   text: Utils.convertPriceVND(item.price*(1-item.discount)),
        //                   style: textStyleError
        //                 ),
        //               ]
        //           )),
        //           const SizedBox(
        //             height: 8.0,
        //           ),
        //           //
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: <Widget>[
        //               Row(
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 children: <Widget>[
        //                   const Icon(
        //                     Icons.star,
        //                     color: Colors.yellowAccent,
        //                   ),
        //                   Text(item.rate.toString()),
        //                 ],
        //               ),
        //               Text('Đã bán: ${item.numSold}', maxLines: 1, overflow: TextOverflow.ellipsis,),
        //             ],
        //           ),
        //           const SizedBox(
        //             height: 8.0,
        //           ),
        //           //tỉnh
        //           Text(
        //             item.province,
        //             style: textStyleLabelChild,
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
        onTap: () async {
          // log(item.itemID.toString());
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ItemDetailScreen(
                    itemID: item.itemID,
                  )));
        },
      ),
    );
  }
}
