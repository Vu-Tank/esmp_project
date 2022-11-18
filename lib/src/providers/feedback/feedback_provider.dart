import 'dart:developer';
import 'dart:io';

import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/feedback.dart';
import 'package:esmp_project/src/models/rating.dart';
import 'package:esmp_project/src/repositoty/order_repository.dart';
import 'package:flutter/material.dart';

class FeedbackProvider extends ChangeNotifier {
  List<File> image = [];
  int _rating = 0;

  int get rating => _rating;

  void reset() {
    _rating = 0;
    image = [];
    notifyListeners();
  }

  void updateRating(int value) {
    _rating = value;
    notifyListeners();
  }

  void addImage(File file) {
    image.add(file);
    notifyListeners();
  }

  void deleteImage(int index) {
    image.removeAt(index);
    notifyListeners();
  }

  Future<ApiResponse> upLoadFeedback(
      {required String token,
      required int orderDetailID,
      required String text,
      required Function onSuccess,
      required Function onFailed }) async {
    // log('text: $text');
    ApiResponse apiResponse = await OrderRepository.feedbackOrderDetail(
        orderDetailID: orderDetailID,
        rate: _rating,
        text: text,
        token: token,
        files: image);
    if (apiResponse.isSuccess!) {
      FeedbackModel feedbackModel=apiResponse.dataResponse as FeedbackModel;
      reset();
      onSuccess(feedbackModel);
    } else {
      onFailed(apiResponse.message!);
    }
    return apiResponse;
  }
}
