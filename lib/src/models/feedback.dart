import 'package:esmp_project/src/models/imageModel.dart';

class Feedback {
  String userName;
  int userID;
  int orderDetailID;
  String userAvatar;
  String subItemName;
  List<ImageModel> imagesFB;
  double rate;
  String comment;
  String createDate;

  Feedback(
      {required this.userName,
        required this.userID,
      required this.orderDetailID,
      required this.userAvatar,
      required this.subItemName,
      required this.imagesFB,
      required this.rate,
      required this.comment,
      required this.createDate});

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
        userName: json['userName'],
        userID: int.parse(json['userID'].toString()),
        orderDetailID: int.parse(json['orderDetaiID'].toString()),
        userAvatar: json['userAvatar'],
        subItemName: json['sub_itemName'],
        imagesFB: (json['imagesFB'] != null)
            ? (json['imagesFB'] as List)
                .map((image) => ImageModel.fromJson(image))
                .toList()
            : [],
        rate: double.parse(json['rate'].toString()),
        comment: json['comment']??'',
        createDate: json['create_Date']);
  }

  @override
  String toString() {
    return 'Feedback{userName: $userName, userID: $userID, orderDetailID: $orderDetailID, userAvatar: $userAvatar, subItemName: $subItemName, imagesFB: $imagesFB, rate: $rate, comment: $comment, createDate: $createDate}';
  }
}

class FeedbackModel {
  int orderDetaiID;
  String subItemName;
  String subItemImage;
  double? rate;
  String? comment;
  String? createDate;
  List<ImageModel>? imagesFB;
  String? deliveryDate;

  FeedbackModel(
      {required this.orderDetaiID,
      required this.subItemName,
      required this.subItemImage,
      this.rate,
      this.comment,
      this.createDate,
      this.imagesFB,
      this.deliveryDate});

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
        orderDetaiID: int.parse(json['orderDetaiID'].toString()),
        subItemName: json['sub_itemName'],
        subItemImage: json['subItemImage'],
        rate: (json['rate'] == null)
            ? null
            : double.parse(json['rate'].toString()),
        comment: (json['comment'] == null) ? null : json['comment'],
        createDate: (json['create_Date'] == null) ? null : json['create_Date'],
        imagesFB: (json['imagesFB'] == null)
            ? null
            : (json['imagesFB'] as List)
                .map((image) => ImageModel.fromJson(image))
                .toList(),
        deliveryDate: json['delivery_Date'],
    );
  }

  @override
  String toString() {
    return 'FeedbackModel{orderDetaiID: $orderDetaiID, subItemName: $subItemName, subItemImage: $subItemImage, rate: $rate, comment: $comment, createDate: $createDate, imagesFB: $imagesFB}';
  }
}
