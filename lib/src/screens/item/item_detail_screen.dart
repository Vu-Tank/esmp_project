import 'package:esmp_project/src/models/item.dart';
import 'package:esmp_project/src/repositoty/item_repository.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({Key? key, required this.itemID}) : super(key: key);
  final int itemID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ItemRepository.getItemDetail(itemID),
        builder: (context, snapshot) {
          if (snapshot.hasData || snapshot.data != null) {
            ItemDetail itemDetail = snapshot.data!.dataResponse as ItemDetail;
            return _itemDetail(itemDetail, context);
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  _itemDetail(ItemDetail itemDetail, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(itemDetail.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // image
            SizedBox(
              height: height*1/3,
              child: PageView.builder(
                itemCount: itemDetail.listImage.length,
                  itemBuilder: (context, index)
                    => Image.network(itemDetail.listImage[index].path!),
              ),
            ),
            //giá
            SizedBox(height: 8.0,),
            Text('${Utils.convertPriceVND(itemDetail.minPrice)}-${Utils.convertPriceVND(itemDetail.maxPrice)}',style: textStyleError,),
            SizedBox(height: 8.0,),
            Text(itemDetail.name),
          ],
        ),
      ),
    );
  }
}
