import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/service_order_detail.dart';
import 'package:esmp_project/src/repositoty/service_repository.dart';
import 'package:flutter/material.dart';

class ServiceProvider extends ChangeNotifier {
  List<ServiceOrderDetail> _service = <ServiceOrderDetail>[];
  List<ServiceOrderDetail> get service => _service;

  late int _currentUserID;
  late String _currentToken;

  Future<void> initData({required int userID, required String token}) async {
    _currentUserID = userID;
    _currentToken = token;
    ApiResponse apiResponse = await ServiceRepository.getDetailAfterService(
        userID: userID, page: 1, token: token);
    if (apiResponse.isSuccess!) {
      _service.clear();
      _service = apiResponse.dataResponse as List<ServiceOrderDetail>;
      notifyListeners();
    } else {
      throw Exception(apiResponse.message!);
    }
  }
}
