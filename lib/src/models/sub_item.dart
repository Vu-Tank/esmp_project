import 'package:esmp_project/src/models/imageModel.dart';

class SubItem {
  int subItemID;
  String subItemName;
  int amount;
  ImageModel image;
  double price;
  int returnAndExchange;

  SubItem(
      {required this.subItemID,
      required this.subItemName,
      required this.amount,
      required this.image,
      required this.price,
      required this.returnAndExchange});

  factory SubItem.fromJson(Map<String, dynamic> json) {
    return SubItem(
        subItemID: json['sub_ItemID'],
        subItemName: json['sub_ItemName'],
        amount: json['amount'],
        image: ImageModel.fromJson(json['image']),
        price: double.parse(json['price'].toString()),
        returnAndExchange: json['returnAndExchange']);
  }

  @override
  String toString() {
    return 'SubItem{subItemID: $subItemID, subItemName: $subItemName, amount: $amount, image: $image, price: $price,returnAndExchange: $returnAndExchange}';
  }
}
