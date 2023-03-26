// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ServiceDetail {
  int? detailID;
  int? amount;
  ServiceDetail({
    this.detailID,
    this.amount,
  });

  ServiceDetail copyWith({
    int? detailID,
    int? amount,
  }) {
    return ServiceDetail(
      detailID: detailID ?? detailID,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'detailID': detailID,
      'amount': amount,
    };
  }

  factory ServiceDetail.fromMap(Map<String, dynamic> map) {
    return ServiceDetail(
      detailID: map['detailID'] != null ? map['detailID'] as int : null,
      amount: map['amount'] != null ? map['amount'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceDetail.fromJson(String source) =>
      ServiceDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ServiceDetail(\\"detailID\\": $detailID, \\"amount\\": $amount)';

  @override
  bool operator ==(covariant ServiceDetail other) {
    if (identical(this, other)) return true;

    return other.detailID == detailID && other.amount == amount;
  }

  @override
  int get hashCode => detailID.hashCode ^ amount.hashCode;
}
