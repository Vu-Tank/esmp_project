import 'dart:developer';

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
    // return ClipRRect(
    //   borderRadius: BorderRadius.circular(10),
    //   child: GridTile(
    //     footer: GridTileBar(
    //       title: Text(
    //         item.name,
    //         textAlign: TextAlign.center,
    //         softWrap: false,
    //         maxLines: 3,
    //         overflow: TextOverflow.ellipsis,
    //       ),
    //       backgroundColor: Colors.black26,
    //       trailing: IconButton(
    //           icon: Icon(Icons.shopping_cart),
    //           onPressed: () {
    //             log('add to cart');
    //           }),
    //     ),
    //     child: GestureDetector(
    //       onTap: () {
    //         Navigator.of(context).push(
    //             MaterialPageRoute(builder: (context) => ItemDetailScreen(itemID: item.itemID,)));
    //       },
    //       child: Image.network(
    //         item.itemImage,
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //   ),
    // );
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Image.network(
                item.itemImage,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //ten
                  Text(
                    item.name,
                    style: textStyleInputChild,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  //gia
                  Text(
                    Utils.convertPriceVND(item.price),
                    style: textStyleError,
                  ),
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
                      Text('Đã bán'),
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
        onTap: () async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ItemDetailScreen(
                    itemID: item.itemID,
                  )));
        },
      ),
    );
  }
}
