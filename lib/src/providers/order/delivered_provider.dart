import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/order.dart';
import 'package:esmp_project/src/repositoty/order_repository.dart';
import 'package:flutter/material.dart';

class DeliveredProvider extends ChangeNotifier {
  final int status = 5;
  int _currentPage = 0;
  bool _hasMore = true;
  bool get hasMore => _hasMore;
  List<Order> _orders = [];

  List<Order> get orders => _orders;
  late int _currentUserID;
  late String _currentToken;

  Future<void> initData({required int userID, required String token}) async {
    _currentUserID = userID;
    _currentToken = token;
    ApiResponse apiResponse = await OrderRepository.getOldOrder(
        userID: userID, page: 1, shipOrderStatus: status, token: token);
    if (apiResponse.isSuccess!) {
      _orders.clear();
      _orders = apiResponse.dataResponse as List<Order>;
      _hasMore = false;
      if (_orders.isNotEmpty) {
        _currentPage = 1;
      }
      notifyListeners();
    } else {
      throw Exception(apiResponse.message!);
    }
  }

  Future<void> addOrder() async {
    ApiResponse apiResponse = await OrderRepository.getOldOrder(
        userID: _currentUserID,
        page: _currentPage + 1,
        shipOrderStatus: status,
        token: _currentToken);
    if (apiResponse.isSuccess!) {
      List<Order> orders = apiResponse.dataResponse as List<Order>;
      _orders.addAll(orders.toList());
      if (orders.isEmpty) {
        _hasMore = false;
      } else {
        _hasMore = true;
      }
      if (orders.isNotEmpty) {
        _currentPage++;
      }
      notifyListeners();
    } else {
      throw Exception(apiResponse.message!);
    }
  }
}
