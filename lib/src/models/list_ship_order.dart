// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ListOrderShip {
  String? status;
  String? create_Date;
  ListOrderShip({
    this.status,
    this.create_Date,
  });

  ListOrderShip copyWith({
    String? status,
    String? create_Date,
  }) {
    return ListOrderShip(
      status: status ?? this.status,
      create_Date: create_Date ?? this.create_Date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'create_Date': create_Date,
    };
  }

  factory ListOrderShip.fromMap(Map<String, dynamic> map) {
    return ListOrderShip(
      status: map['status'] != null ? map['status'] as String : null,
      create_Date:
          map['create_Date'] != null ? map['create_Date'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListOrderShip.fromJson(String source) =>
      ListOrderShip.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ListOrderShip(status: $status, create_Date: $create_Date)';

  @override
  bool operator ==(covariant ListOrderShip other) {
    if (identical(this, other)) return true;

    return other.status == status && other.create_Date == create_Date;
  }

  @override
  int get hashCode => status.hashCode ^ create_Date.hashCode;
}
