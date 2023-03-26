// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ServiceStatus {
  int? item_StatusID;
  String? statusName;
  ServiceStatus({
    this.item_StatusID,
    this.statusName,
  });

  ServiceStatus copyWith({
    int? item_StatusID,
    String? statusName,
  }) {
    return ServiceStatus(
      item_StatusID: item_StatusID ?? this.item_StatusID,
      statusName: statusName ?? this.statusName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'item_StatusID': item_StatusID,
      'statusName': statusName,
    };
  }

  factory ServiceStatus.fromMap(Map<String, dynamic> map) {
    return ServiceStatus(
      item_StatusID:
          map['item_StatusID'] != null ? map['item_StatusID'] as int : null,
      statusName:
          map['statusName'] != null ? map['statusName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceStatus.fromJson(String source) =>
      ServiceStatus.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ServiceStatus(item_StatusID: $item_StatusID, statusName: $statusName)';

  @override
  bool operator ==(covariant ServiceStatus other) {
    if (identical(this, other)) return true;

    return other.item_StatusID == item_StatusID &&
        other.statusName == statusName;
  }

  @override
  int get hashCode => item_StatusID.hashCode ^ statusName.hashCode;
}