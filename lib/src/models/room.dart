class RoomChat {
  String roomID;
  String createDate;
  String time;
  String recentMessage;
  String recentMessageSender;
  String receiverName;
  String receiverImageUrl;

  RoomChat(
      {required this.roomID,
      required this.createDate,
      required this.time,
      required this.recentMessage,
      required this.recentMessageSender,
      required this.receiverName,
      required this.receiverImageUrl});

  @override
  String toString() {
    return 'RoomChat{roomID: $roomID, createDate: $createDate, time: $time, recentMessage: $recentMessage, recentMessageSender: $recentMessageSender, receiverName: $receiverName, receiverImageUrl: $receiverImageUrl}';
  }
}
