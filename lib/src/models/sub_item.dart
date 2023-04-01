import 'package:esmp_project/src/models/imageModel.dart';
import 'package:esmp_project/src/models/item_status.dart';

class SubItem {
  int subItemID;
  String subItemName;
  int amount;
  ImageModel image;
  double price;
  int returnAndExchange;
  ItemStatus subItem_Status;

  SubItem(
      {required this.subItemID,
      required this.subItemName,
      required this.amount,
      required this.image,
      required this.price,
      required this.returnAndExchange,
      required this.subItem_Status});

  factory SubItem.fromJson(Map<String, dynamic> json) {
    return SubItem(
        subItemID: json['sub_ItemID'],
        subItemName: json['sub_ItemName'],
        amount: json['amount'],
        image: ImageModel.fromJson(json['image']),
        price: double.parse(json['price'].toString()),
        returnAndExchange: json['returnAndExchange'],
        subItem_Status: ItemStatus.fromMap(json['subItem_Status']));
  }

  @override
  String toString() {
    return 'SubItem{subItemID: $subItemID, subItemName: $subItemName, amount: $amount, image: $image, price: $price,returnAndExchange: $returnAndExchange, subItem_Status: $subItem_Status}';
  }
}
