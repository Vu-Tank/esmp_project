// ignore_for_file: public_member_api_docs, sort_constructors_first

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
