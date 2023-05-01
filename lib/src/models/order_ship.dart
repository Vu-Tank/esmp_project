// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:esmp_project/src/models/list_ship_order.dart';

class OrderShip {
  String labelID;
  String reasonCode;
  String reason;
  String status;
  String createDate;

  OrderShip(
      {required this.labelID,
      required this.reasonCode,
      required this.reason,
      required this.status,
      required this.createDate});

  factory OrderShip.fromJson(Map<String, dynamic> json) {
    return OrderShip(
        labelID: json['labelID'],
        reasonCode: json['reason_code'],
        reason: json['reason'],
        status: json['status'],
        createDate: json['create_Date']);
  }

  @override
  String toString() {
    return 'OrderShip{labelID: $labelID, reasonCode: $reasonCode, reason: $reason, status: $status, createDate: $createDate}';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'labelID': labelID,
      'reasonCode': reasonCode,
      'reason': reason,
      'status': status,
      'createDate': createDate,
    };
  }
}

class ListShip {
  String labelID;
  int orderID;
  List<ListOrderShip>? orderShip;
  ListShip({
    required this.labelID,
    required this.orderID,
    this.orderShip,
  });

  ListShip copyWith({
    String? labelID,
    int? orderID,
    List<ListOrderShip>? orderShip,
  }) {
    return ListShip(
      labelID: labelID ?? this.labelID,
      orderID: orderID ?? this.orderID,
      orderShip: orderShip ?? this.orderShip,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'labelID': labelID,
      'orderID': orderID,
      'shipStatusModels': orderShip!.map((x) => x.toMap()).toList(),
    };
  }

  factory ListShip.fromMap(Map<String, dynamic> map) {
    return ListShip(
      labelID: map['labelID'] as String,
      orderID: map['orderID'] as int,
      orderShip: map['shipStatusModels'] != null
          ? List<ListOrderShip>.from(
              (map['shipStatusModels'] as List<dynamic>).map<ListOrderShip?>(
                (x) => ListOrderShip.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListShip.fromJson(String source) =>
      ListShip.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ListShip(labelID: $labelID, orderID: $orderID, orderShip: $orderShip)';

  @override
  bool operator ==(covariant ListShip other) {
    if (identical(this, other)) return true;

    return other.labelID == labelID &&
        other.orderID == orderID &&
        listEquals(other.orderShip, orderShip);
  }

  @override
  int get hashCode => labelID.hashCode ^ orderID.hashCode ^ orderShip.hashCode;
}
