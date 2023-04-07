import 'dart:convert';

import 'package:esmp_project/src/models/imageModel.dart';

class FeedBackData {
  final String userName;
  final int userID;
  final int orderDetaiID;
  final String userAvatar;
  final String sub_itemName;
  final List<ImageData>? imagesFB;
  final double? rate;
  final String? comment;
  final String create_Date;
  final FeedbackStatus feedback_Status;
  FeedBackData(
      {required this.userName,
      required this.userID,
      required this.orderDetaiID,
      required this.userAvatar,
      required this.sub_itemName,
      this.imagesFB,
      this.rate,
      required this.comment,
      required this.create_Date,
      required this.feedback_Status});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'userID': userID,
      'orderDetaiID': orderDetaiID,
      'userAvatar': userAvatar,
      'sub_itemName': sub_itemName,
      'imagesFB': imagesFB?.map((x) => x.toMap()).toList(),
      'rate': rate,
      'comment': comment,
      'create_Date': create_Date,
      'feedback_Status': feedback_Status.toMap(),
    };
  }

  factory FeedBackData.fromMap(Map<String, dynamic> map) {
    return FeedBackData(
      userName: map['userName'] as String,
      userID: map['userID'] as int,
      orderDetaiID: map['orderDetaiID'] as int,
      userAvatar: map['userAvatar'] as String,
      sub_itemName: map['sub_itemName'] as String,
      imagesFB: map['imagesFB'] != null
          ? List<ImageData>.from(
              (map['imagesFB'] as List).map<ImageData?>(
                (x) => ImageData.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      rate: (map['rate'] == null) ? null : double.parse(map['rate'].toString()),
      comment: (map['comment'] != null) ? map['comment'] as String : null,
      create_Date: map['create_Date'] as String,
      feedback_Status: FeedbackStatus.fromMap(
          map['feedback_Status'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory FeedBackData.fromJson(String source) =>
      FeedBackData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FeedBack(userName: $userName, userID: $userID, orderDetaiID: $orderDetaiID, userAvatar: $userAvatar, sub_itemName: $sub_itemName, imagesFB: $imagesFB, rate: $rate, comment: $comment, create_Date: $create_Date, feedback_Status: $feedback_Status)';
  }
}

class FeedbackStatus {
  final int item_StatusID;
  final String statusName;
  FeedbackStatus({
    required this.item_StatusID,
    required this.statusName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'item_StatusID': item_StatusID,
      'statusName': statusName,
    };
  }

  factory FeedbackStatus.fromMap(Map<String, dynamic> map) {
    return FeedbackStatus(
      item_StatusID: map['item_StatusID'] as int,
      statusName: map['statusName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FeedbackStatus.fromJson(String source) =>
      FeedbackStatus.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FeedbackStatus(item_StatusID: $item_StatusID, statusName: $statusName)';
}

class ImageData {
  final int imageID;
  final String fileName;
  final String path;
  final String crete_date;
  final bool isActive;
  ImageData({
    required this.imageID,
    required this.fileName,
    required this.path,
    required this.crete_date,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imageID': imageID,
      'fileName': fileName,
      'path': path,
      'crete_date': crete_date,
      'isActive': isActive,
    };
  }

  factory ImageData.fromMap(Map<String, dynamic> map) {
    return ImageData(
      imageID: map['imageID'] as int,
      fileName: map['fileName'] as String,
      path: map['path'] as String,
      crete_date: map['crete_date'] as String,
      isActive: map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageData.fromJson(String source) =>
      ImageData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Image(imageID: $imageID, fileName: $fileName, path: $path, crete_date: $crete_date, isActive: $isActive)';
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
      rate:
          (json['rate'] == null) ? null : double.parse(json['rate'].toString()),
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
