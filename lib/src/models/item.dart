import 'dart:developer';

import 'package:esmp_project/src/models/Motor_brand.dart';
import 'package:esmp_project/src/models/feedback.dart';
import 'package:esmp_project/src/models/imageModel.dart';
import 'package:esmp_project/src/models/specificationItem.dart';
import 'package:esmp_project/src/models/store.dart';
import 'package:esmp_project/src/models/sub_item.dart';

class Item {
  int itemID;
  String name;
  String description;
  double discount;
  double rate;
  double price;
  String itemImage;
  String province;
  int numSold;

  Item(
      {required this.itemID,
      required this.name,
      required this.description,
      required this.discount,
      required this.rate,
      required this.price,
      required this.itemImage,
      required this.province,
      required this.numSold});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        itemID: json['itemID'],
        name: json['name'] as String,
        description: json['description'] as String,
        discount: double.parse(json['discount'].toString()),
        rate: double.parse(json['rate'].toString()),
        price: double.parse(json['price'].toString()),
        itemImage: json['item_Image'] as String,
        province: json['province'] as String,
        numSold: json['num_Sold'] as int
    );

  }

  @override
  String toString() {
    return 'Item{itemID: $itemID, name: $name, description: $description, discount: $discount, rate: $rate, price: $price, itemImage: $itemImage, province: $province, numSold: $numSold}';
  }
}

class ItemDetail {
  int itemID;
  String name;
  String description;
  double rate;
  double maxPrice;
  double minPrice;
  double discount;
  int numSold;
  String createDate;
  List<ImageModel> listImage;
  List<SpecificationItem> listSpecification;
  Store store;
  List<SubItem> listSubItem;
  List<MotorBrand> listMotorBrand;
  List<Feedback> listFeedback;
  ItemDetail(
      {required this.itemID,
      required this.name,
      required this.description,
      required this.rate,
      required this.maxPrice,
      required this.minPrice,
      required this.discount,
      required this.numSold,
      required this.createDate,
      required this.listImage,
      required this.listSpecification,
      required this.store,
      required this.listSubItem,
      required this.listMotorBrand,
      required this.listFeedback});

  factory ItemDetail.fromJson(Map<String, dynamic> json) {
    return ItemDetail(
        itemID: json['itemID'],
        name: json['name'],
        description: json['description'],
        rate: double.parse(json['rate'].toString()),
        maxPrice: double.parse(json['maxPrice'].toString()),
        minPrice: double.parse(json['minPrice'].toString()),
        discount: double.parse(json['discount'].toString()),
        numSold: json['num_Sold'],
        createDate: json['create_date'],
        listImage: (json['list_Image'] as List).map((image) => ImageModel.fromJson(image)).toList(),
        listSpecification: (json['specification_Tag'] as List).map((specification) => SpecificationItem.fromJson(specification)).toList(),
        store: Store.fromJson(json['store']),
        listSubItem: (json['listSubItem'] as List).map((subItem) => SubItem.fromJson(subItem)).toList(),
        listMotorBrand: (json['listModel'] as List).map((motorBrand) => MotorBrand.fromJson(motorBrand)).toList(),
        listFeedback: (json['listFeedBack']as List).map((feedback) => Feedback.fromJson(feedback)).toList(),
    );
  }

  @override
  String toString() {
    return 'ItemDetail{itemID: $itemID, name: $name, description: $description, rate: $rate, maxPrice: $maxPrice, minPrice: $minPrice, discount: $discount, numSold: $numSold, createDate: $createDate, listImage: $listImage, listSpecification: $listSpecification, store: $store, listSubItem: $listSubItem, listMotorBrand: $listMotorBrand, listFeedback: $listFeedback}';
  }
}
