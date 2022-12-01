class StatusOrder{
  int orderStatusID;
  String statusName;

  StatusOrder({required this.orderStatusID,required this.statusName});
  
  factory StatusOrder.fromJson(Map<String, dynamic> json) {
    return StatusOrder(orderStatusID: json['item_StatusID'], statusName: json['statusName']);
  }

  @override
  String toString() {
    return 'StatusOrder{orderStatusID: $orderStatusID, statusName: $statusName}';
  }
}