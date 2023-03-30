import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/service_order_detail.dart';
import 'package:esmp_project/src/repositoty/service_repository.dart';
import 'package:flutter/material.dart';

class ServiceProvider extends ChangeNotifier {
  List<ServiceOrderDetail> _service = <ServiceOrderDetail>[];
  List<ServiceOrderDetail> get service => _service;
  int currentPage = 0;
  bool _hasMore = true;
  final int limited = 10;

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
      if (_service.length < limited) {
        _hasMore = false;
      } else {
        _hasMore = true;
      }
      if (_service.isNotEmpty) {
        currentPage = 1;
      }
      notifyListeners();
    } else {
      throw Exception(apiResponse.message!);
    }
  }

  Future<void> addData() async {
    if (hasMore) {
      ApiResponse apiResponse = await ServiceRepository.getDetailAfterService(
          userID: _currentUserID, page: currentPage + 1, token: _currentToken);
      if (apiResponse.isSuccess!) {
        List<ServiceOrderDetail> service =
            apiResponse.dataResponse as List<ServiceOrderDetail>;
        _service.addAll(service.toList());
        if (service.length < limited) {
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
  }
}
