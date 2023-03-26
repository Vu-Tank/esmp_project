// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:esmp_project/src/models/service_detail.dart';

class ReturnExchange {
  String? create_Date;
  List<String>? packingLinkCus;
  List<ServiceDetail>? list_ServiceDetail;
  int? orderID;
  int? addressID;
  int? serviceType;
  List<String>? text;
  ReturnExchange({
    required this.create_Date,
    required this.packingLinkCus,
    required this.list_ServiceDetail,
    required this.orderID,
    required this.addressID,
    required this.serviceType,
    required this.text,
  });

  ReturnExchange copyWith(
      {String? create_Date,
      List<String>? packingLinkCus,
      List<ServiceDetail>? list_ServiceDetail,
      int? orderID,
      int? addressID,
      int? serviceType,
      List<String>? text}) {
    return ReturnExchange(
      create_Date: create_Date ?? this.create_Date,
      packingLinkCus: packingLinkCus ?? this.packingLinkCus,
      list_ServiceDetail: list_ServiceDetail ?? this.list_ServiceDetail,
      orderID: orderID ?? this.orderID,
      addressID: addressID ?? this.addressID,
      serviceType: serviceType ?? this.serviceType,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'create_Date': create_Date,
      'packingLinkCus': packingLinkCus,
      'list_ServiceDetail': list_ServiceDetail?.map((x) => x.toMap()).toList(),
      'orderID': orderID,
      'addressID': addressID,
      'serviceType': serviceType,
      'text': text
    };
  }

  factory ReturnExchange.fromMap(Map<String, dynamic> map) {
    return ReturnExchange(
      create_Date:
          map['create_Date'] != null ? map['create_Date'] as String : null,
      packingLinkCus: map['packingLinkCus'] != null
          ? List<String>.from((map['packingLinkCus'] as List<String>))
          : null,
      list_ServiceDetail: map['list_ServiceDetail'] != null
          ? List<ServiceDetail>.from(
              (map['list_ServiceDetail'] as List<int>).map<ServiceDetail?>(
                (x) => ServiceDetail.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      orderID: map['orderID'] != null ? map['orderID'] as int : null,
      addressID: map['addressID'] != null ? map['addressID'] as int : null,
      serviceType:
          map['serviceType'] != null ? map['serviceType'] as int : null,
      text: map['text'] != null
          ? List<String>.from((map['text'] as List<String>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReturnExchange.fromJson(String source) =>
      ReturnExchange.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReturnExchange(create_Date: $create_Date, packingLinkCus: $packingLinkCus, list_ServiceDetail: $list_ServiceDetail, orderID: $orderID, addressID: $addressID, serviceType: $serviceType, text: $text)';
  }

  @override
  bool operator ==(covariant ReturnExchange other) {
    if (identical(this, other)) return true;

    return other.create_Date == create_Date &&
        listEquals(other.packingLinkCus, packingLinkCus) &&
        listEquals(other.list_ServiceDetail, list_ServiceDetail) &&
        other.orderID == orderID &&
        other.addressID == addressID &&
        other.serviceType == serviceType &&
        other.text == text;
  }

  @override
  int get hashCode {
    return create_Date.hashCode ^
        packingLinkCus.hashCode ^
        list_ServiceDetail.hashCode ^
        orderID.hashCode ^
        addressID.hashCode ^
        serviceType.hashCode ^
        text.hashCode;
  }
}
