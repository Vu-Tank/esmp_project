// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:esmp_project/src/models/service_status.dart';

class DataExchange {
  int? exchangeUserID;
  String? exchangeUserName;
  int? exchangePrice;
  String? create_date;
  ServiceStatus? exchangeStatus;
  String? image;
  int? orderID;
  String? bankName;
  String? cardNum;
  String? cardHoldName;
  int? afterBuyServiceID;
  DataExchange({
    this.exchangeUserID,
    this.exchangeUserName,
    this.exchangePrice,
    this.create_date,
    this.exchangeStatus,
    this.image,
    this.orderID,
    this.bankName,
    this.cardNum,
    this.cardHoldName,
    this.afterBuyServiceID,
  });

  DataExchange copyWith({
    int? exchangeUserID,
    String? exchangeUserName,
    int? exchangePrice,
    String? create_date,
    ServiceStatus? exchangeStatus,
    String? image,
    int? orderID,
    String? bankName,
    String? cardNum,
    String? cardHoldName,
    int? afterBuyServiceID,
  }) {
    return DataExchange(
      exchangeUserID: exchangeUserID ?? this.exchangeUserID,
      exchangeUserName: exchangeUserName ?? this.exchangeUserName,
      exchangePrice: exchangePrice ?? this.exchangePrice,
      create_date: create_date ?? this.create_date,
      exchangeStatus: exchangeStatus ?? this.exchangeStatus,
      image: image ?? this.image,
      orderID: orderID ?? this.orderID,
      bankName: bankName ?? this.bankName,
      cardNum: cardNum ?? this.cardNum,
      cardHoldName: cardHoldName ?? this.cardHoldName,
      afterBuyServiceID: afterBuyServiceID ?? this.afterBuyServiceID,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'exchangeUserID': exchangeUserID,
      'exchangeUserName': exchangeUserName,
      'exchangePrice': exchangePrice,
      'create_date': create_date,
      'exchangeStatus': exchangeStatus?.toMap(),
      'image': image,
      'orderID': orderID,
      'bankName': bankName,
      'cardNum': cardNum,
      'cardHoldName': cardHoldName,
      'afterBuyServiceID': afterBuyServiceID,
    };
  }

  factory DataExchange.fromMap(Map<String, dynamic> map) {
    return DataExchange(
      exchangeUserID:
          map['exchangeUserID'] != null ? map['exchangeUserID'] as int : null,
      exchangeUserName: map['exchangeUserName'] != null
          ? map['exchangeUserName'] as String
          : null,
      exchangePrice:
          map['exchangePrice'] != null ? map['exchangePrice'] as int : null,
      create_date:
          map['create_date'] != null ? map['create_date'] as String : null,
      exchangeStatus: map['exchangeStatus'] != null
          ? ServiceStatus.fromMap(map['exchangeStatus'] as Map<String, dynamic>)
          : null,
      image: map['image'] != null ? map['image'] as String : null,
      orderID: map['orderID'] != null ? map['orderID'] as int : null,
      bankName: map['bankName'] != null ? map['bankName'] as String : null,
      cardNum: map['cardNum'] != null ? map['cardNum'] as String : null,
      cardHoldName:
          map['cardHoldName'] != null ? map['cardHoldName'] as String : null,
      afterBuyServiceID: map['afterBuyServiceID'] != null
          ? map['afterBuyServiceID'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DataExchange.fromJson(String source) =>
      DataExchange.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DataExchange(exchangeUserID: $exchangeUserID, exchangeUserName: $exchangeUserName, exchangePrice: $exchangePrice, create_date: $create_date, exchangeStatus: $exchangeStatus, image: $image, orderID: $orderID, bankName: $bankName, cardNum: $cardNum, cardHoldName: $cardHoldName, afterBuyServiceID: $afterBuyServiceID)';
  }

  @override
  bool operator ==(covariant DataExchange other) {
    if (identical(this, other)) return true;

    return other.exchangeUserID == exchangeUserID &&
        other.exchangeUserName == exchangeUserName &&
        other.exchangePrice == exchangePrice &&
        other.create_date == create_date &&
        other.exchangeStatus == exchangeStatus &&
        other.image == image &&
        other.orderID == orderID &&
        other.bankName == bankName &&
        other.cardNum == cardNum &&
        other.cardHoldName == cardHoldName &&
        other.afterBuyServiceID == afterBuyServiceID;
  }

  @override
  int get hashCode {
    return exchangeUserID.hashCode ^
        exchangeUserName.hashCode ^
        exchangePrice.hashCode ^
        create_date.hashCode ^
        exchangeStatus.hashCode ^
        image.hashCode ^
        orderID.hashCode ^
        bankName.hashCode ^
        cardNum.hashCode ^
        cardHoldName.hashCode ^
        afterBuyServiceID.hashCode;
  }
}
