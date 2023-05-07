// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:esmp_project/src/models/imageModel.dart';

class OrderDetail {
  int orderDetailID;
  double pricePurchase;
  double discountPurchase;
  int amount;
  String? feedbackTitle;
  double? feedbackRate;
  String? feedBackDate;
  int subItemID;
  String subItemName;
  String subItemImage;
  int itemID;
  int returnAndExchange;
  String? timeReturn;
  List<ImageModel>? listImageFb;

  OrderDetail(
      {required this.orderDetailID,
      required this.pricePurchase,
      required this.discountPurchase,
      required this.amount,
      this.feedbackTitle,
      this.feedbackRate,
      this.feedBackDate,
      required this.subItemID,
      required this.subItemName,
      required this.subItemImage,
      required this.itemID,
      required this.returnAndExchange,
      this.timeReturn,
      this.listImageFb});

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      orderDetailID: json['orderDetailID'] as int,
      pricePurchase: double.parse(json['pricePurchase'].toString()),
      discountPurchase: double.parse(json['discountPurchase'].toString()),
      amount: json['amount'] as int,
      subItemID: json['sub_ItemID'] as int,
      subItemName: json['sub_ItemName'] as String,
      subItemImage: json['sub_ItemImage'] as String,
      itemID: json['itemID'] as int,
      returnAndExchange: json['returnAndExchange'] as int,
      listImageFb: json['listImageFb'] == null
          ? null
          : (json['listImageFb'] as List)
              .map((image) => ImageModel.fromJson(image))
              .toList(),
      feedbackRate: json['feedback_Rate'] != null
          ? double.parse(json['feedback_Rate'].toString())
          : null,
      feedBackDate: json['feedBack_Date'],
      feedbackTitle: json['feedback_Title'],
      timeReturn:
          json['timeReturn'] != null ? json['timeReturn'] as String : null,
    );
  }

  @override
  String toString() {
    return 'OrderDetail(orderDetailID: $orderDetailID, pricePurchase: $pricePurchase, discountPurchase: $discountPurchase, amount: $amount, feedbackTitle: $feedbackTitle, feedbackRate: $feedbackRate, feedBackDate: $feedBackDate, subItemID: $subItemID, subItemName: $subItemName, subItemImage: $subItemImage, itemID: $itemID, returnAndExchange: $returnAndExchange, timeReturn: $timeReturn, listImageFb: $listImageFb)';
  }
}
