import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/feedback.dart';
import 'package:esmp_project/src/repositoty/order_repository.dart';
import 'package:flutter/material.dart';

class NotYetFeedbackProvider extends ChangeNotifier{
  List<FeedbackModel> _listFeedback = [];
  bool hasMore = true;
  final int _limit = 25;
  int pageIndex = 0;

  List<FeedbackModel> get listFeedback => _listFeedback;

  Future<void> initData({required int userID, required String token}) async {
    ApiResponse apiResponse = await OrderRepository.getListFeedback(
        userID: userID, isFeedback: true, page: 1, token: token);
    if(apiResponse.isSuccess!){
      _listFeedback=apiResponse.dataResponse as List<FeedbackModel>;
      if(_listFeedback.length<_limit){
        hasMore=false;
      }else{
        hasMore=true;
      }
      pageIndex=1;
      notifyListeners();
    }else{
      throw Exception(apiResponse.message!);
    }
  }
}