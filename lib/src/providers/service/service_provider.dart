import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/service_order_detail.dart';
import 'package:esmp_project/src/repositoty/service_repository.dart';
import 'package:flutter/material.dart';

class ServiceProvider extends ChangeNotifier {
  List<ServiceOrderDetail> _service = <ServiceOrderDetail>[];
  List<ServiceOrderDetail> get service => _service;
  int currentPage = 0;
  bool _hasMore = true;

  bool get hasMore => _hasMore;
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

      _hasMore = false;

      if (_service.isNotEmpty) {
        currentPage = 1;
      }
      notifyListeners();
    } else {
      throw Exception(apiResponse.message!);
    }
  }

  Future<void> addData() async {
    ApiResponse apiResponse = await ServiceRepository.getDetailAfterService(
        userID: _currentUserID, page: currentPage + 1, token: _currentToken);
    if (apiResponse.isSuccess!) {
      List<ServiceOrderDetail> service =
          apiResponse.dataResponse as List<ServiceOrderDetail>;
      _service.addAll(service.toList());
      if (service.isEmpty) {
        _hasMore = false;
      } else {
        _hasMore = true;
      }
      if (service.isNotEmpty) {
        currentPage++;
      }
      notifyListeners();
    } else {
      throw Exception(apiResponse.message!);
    }
  }

  Future<void> getServiceByOrder(
      {required int userID,
      required String token,
      required int orderID}) async {
    _currentUserID = userID;
    _currentToken = token;
    ApiResponse apiResponse = await ServiceRepository.getDetailAfterService(
        userID: userID, page: 1, token: token, orderID: orderID);
    if (apiResponse.isSuccess!) {
      _service.clear();
      _service = apiResponse.dataResponse as List<ServiceOrderDetail>;
      notifyListeners();
    } else {
      throw Exception(apiResponse.message!);
    }
  }
}
