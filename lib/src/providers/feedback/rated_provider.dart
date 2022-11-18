import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/feedback.dart';
import 'package:esmp_project/src/repositoty/order_repository.dart';
import 'package:flutter/material.dart';

class RatedProvider extends ChangeNotifier {
  List<FeedbackModel> _listFeedback = [];
  bool hasMore = true;
  final int _limit = 25;
  int pageIndex = 0;
  late String _token;
  late int _userID;
  List<FeedbackModel> get listFeedback => _listFeedback;

  Future<void> initData({required int userID, required String token}) async {
    ApiResponse apiResponse = await OrderRepository.getListFeedback(
        userID: userID, isFeedback: false, page: 1, token: token);
    if(apiResponse.isSuccess!){
      _userID=userID;
      _token=token;
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
  Future<void> addData()async{
    ApiResponse apiResponse = await OrderRepository.getListFeedback(
        userID: _userID, isFeedback: false, page: pageIndex+1, token: _token);
    if(apiResponse.isSuccess!){
      List<FeedbackModel> data=apiResponse.dataResponse as List<FeedbackModel>;
      _listFeedback.addAll(data);
      if(data.length<_limit){
        hasMore=false;
      }else{
        hasMore=true;
      }
      if(data.isNotEmpty){
        pageIndex++;
      }
      notifyListeners();
    }else{
      throw Exception(apiResponse.message!);
    }
  }
}
