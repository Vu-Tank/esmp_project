// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DetailAfterService {
  int? afterBuyServiceDetailID;
  int? pricePurchase;
  double? discountPurchase;
  int? amount;
  int? sub_ItemID;
  String? sub_ItemName;
  String? sub_ItemImage;
  int? itemID;
  DetailAfterService({
    this.afterBuyServiceDetailID,
    this.pricePurchase,
    this.discountPurchase,
    this.amount,
    this.sub_ItemID,
    this.sub_ItemName,
    this.sub_ItemImage,
    this.itemID,
  });

  DetailAfterService copyWith({
    int? afterBuyServiceDetailID,
    int? pricePurchase,
    double? discountPurchase,
    int? amount,
    int? sub_ItemID,
    String? sub_ItemName,
    String? sub_ItemImage,
    int? itemID,
  }) {
    return DetailAfterService(
      afterBuyServiceDetailID:
          afterBuyServiceDetailID ?? this.afterBuyServiceDetailID,
      pricePurchase: pricePurchase ?? this.pricePurchase,
      discountPurchase: discountPurchase ?? this.discountPurchase,
      amount: amount ?? this.amount,
      sub_ItemID: sub_ItemID ?? this.sub_ItemID,
      sub_ItemName: sub_ItemName ?? this.sub_ItemName,
      sub_ItemImage: sub_ItemImage ?? this.sub_ItemImage,
      itemID: itemID ?? this.itemID,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'afterBuyServiceDetailID': afterBuyServiceDetailID,
      'pricePurchase': pricePurchase,
      'discountPurchase': discountPurchase,
      'amount': amount,
      'sub_ItemID': sub_ItemID,
      'sub_ItemName': sub_ItemName,
      'sub_ItemImage': sub_ItemImage,
      'itemID': itemID,
    };
  }

  factory DetailAfterService.fromMap(Map<String, dynamic> map) {
    return DetailAfterService(
      afterBuyServiceDetailID: map['afterBuyServiceDetailID'] != null
          ? map['afterBuyServiceDetailID'] as int
          : null,
      pricePurchase:
          map['pricePurchase'] != null ? map['pricePurchase'] as int : null,
      discountPurchase: double.parse(map['discountPurchase'].toString()),
      amount: map['amount'] != null ? map['amount'] as int : null,
      sub_ItemID: map['sub_ItemID'] != null ? map['sub_ItemID'] as int : null,
      sub_ItemName:
          map['sub_ItemName'] != null ? map['sub_ItemName'] as String : null,
      sub_ItemImage:
          map['sub_ItemImage'] != null ? map['sub_ItemImage'] as String : null,
      itemID: map['itemID'] != null ? map['itemID'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DetailAfterService.fromJson(String source) =>
      DetailAfterService.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DetailAfterService(afterBuyServiceDetailID: $afterBuyServiceDetailID, pricePurchase: $pricePurchase, discountPurchase: $discountPurchase, amount: $amount, sub_ItemID: $sub_ItemID, sub_ItemName: $sub_ItemName, sub_ItemImage: $sub_ItemImage, itemID: $itemID)';
  }

  @override
  bool operator ==(covariant DetailAfterService other) {
    if (identical(this, other)) return true;

    return other.afterBuyServiceDetailID == afterBuyServiceDetailID &&
        other.pricePurchase == pricePurchase &&
        other.discountPurchase == discountPurchase &&
        other.amount == amount &&
        other.sub_ItemID == sub_ItemID &&
        other.sub_ItemName == sub_ItemName &&
        other.sub_ItemImage == sub_ItemImage &&
        other.itemID == itemID;
  }

  @override
  int get hashCode {
    return afterBuyServiceDetailID.hashCode ^
        pricePurchase.hashCode ^
        discountPurchase.hashCode ^
        amount.hashCode ^
        sub_ItemID.hashCode ^
        sub_ItemName.hashCode ^
        sub_ItemImage.hashCode ^
        itemID.hashCode;
  }
}
