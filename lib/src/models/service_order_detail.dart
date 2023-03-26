// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:esmp_project/src/models/detail_after_service.dart';
import 'package:esmp_project/src/models/service_status.dart';
import 'package:esmp_project/src/models/service_type.dart';
import 'package:esmp_project/src/models/store.dart';

class ServiceOrderDetail {
  int? afterBuyServiceID;
  int? orderID;
  String? create_Date;
  ServiceStatus? servicestatus;
  ServiceType? serviceType;
  List<DetailAfterService>? details;
  Store? storeView;
  ServiceOrderDetail({
    this.afterBuyServiceID,
    this.orderID,
    this.create_Date,
    this.servicestatus,
    this.serviceType,
    this.details,
    this.storeView,
  });

  ServiceOrderDetail copyWith({
    int? afterBuyServiceID,
    int? orderID,
    String? create_Date,
    ServiceStatus? servicestatus,
    ServiceType? serviceType,
    List<DetailAfterService>? details,
    Store? storeView,
  }) {
    return ServiceOrderDetail(
      afterBuyServiceID: afterBuyServiceID ?? this.afterBuyServiceID,
      orderID: orderID ?? this.orderID,
      create_Date: create_Date ?? this.create_Date,
      servicestatus: servicestatus ?? this.servicestatus,
      serviceType: serviceType ?? this.serviceType,
      details: details ?? this.details,
      storeView: storeView ?? this.storeView,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'afterBuyServiceID': afterBuyServiceID,
      'orderID': orderID,
      'create_Date': create_Date,
      'servicestatus': servicestatus?.toMap(),
      'serviceType': serviceType?.toMap(),
      'details': details!.map((x) => x.toMap()).toList(),
      'storeView': storeView?.toMap(),
    };
  }

  factory ServiceOrderDetail.fromMap(Map<String, dynamic> map) {
    return ServiceOrderDetail(
      afterBuyServiceID: map['afterBuyServiceID'] != null
          ? map['afterBuyServiceID'] as int
          : null,
      orderID: map['orderID'] != null ? map['orderID'] as int : null,
      create_Date:
          map['create_Date'] != null ? map['create_Date'] as String : null,
      servicestatus: map['servicestatus'] != null
          ? ServiceStatus.fromMap(map['servicestatus'] as Map<String, dynamic>)
          : null,
      serviceType: map['serviceType'] != null
          ? ServiceType.fromMap(map['serviceType'] as Map<String, dynamic>)
          : null,
      details: map['details'] != null
          ? List<DetailAfterService>.from(
              (map['details'] as List<dynamic>).map<DetailAfterService?>(
                (x) => DetailAfterService.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      storeView: map['storeView'] != null
          ? Store.fromJson(map['storeView'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceOrderDetail.fromJson(String source) =>
      ServiceOrderDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ServiceOrderDetail(afterBuyServiceID: $afterBuyServiceID, orderID: $orderID, create_Date: $create_Date, servicestatus: $servicestatus, serviceType: $serviceType, details: $details, storeView: $storeView)';
  }

  @override
  bool operator ==(covariant ServiceOrderDetail other) {
    if (identical(this, other)) return true;

    return other.afterBuyServiceID == afterBuyServiceID &&
        other.orderID == orderID &&
        other.create_Date == create_Date &&
        other.servicestatus == servicestatus &&
        other.serviceType == serviceType &&
        listEquals(other.details, details) &&
        other.storeView == storeView;
  }

  @override
  int get hashCode {
    return afterBuyServiceID.hashCode ^
        orderID.hashCode ^
        create_Date.hashCode ^
        servicestatus.hashCode ^
        serviceType.hashCode ^
        details.hashCode ^
        storeView.hashCode;
  }
}
