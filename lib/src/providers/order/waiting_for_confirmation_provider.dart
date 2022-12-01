import 'dart:developer';

import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/order.dart';
import 'package:esmp_project/src/repositoty/order_repository.dart';
import 'package:flutter/material.dart';

class WaitingForConfirmationProvider extends ChangeNotifier{
  final int status=1;
  int _currentPage = 0;
  bool _hasMore = true;
  final int _limited = 25;

  bool get hasMore => _hasMore;
  List<Order> _orders = [];

  List<Order> get orders => _orders;
  late int _currentUserID;
  late String _currentToken;

  Future<void> initData(
      {required int userID, required String token}) async {
    _currentUserID = userID;
    _currentToken = token;
    ApiResponse apiResponse = await OrderRepository.getOldOrder(
        userID: userID, page: 1, shipOrderStatus: status, token: token);
    if (apiResponse.isSuccess!) {
      _orders.clear();
      _orders = apiResponse.dataResponse as List<Order>;
      if (_orders.length < _limited) {
        _hasMore = false;
      } else {
        _hasMore = true;
      }
      if (_orders.isNotEmpty) {
        _currentPage = 1;
      }
      notifyListeners();
    } else {
      throw Exception(apiResponse.message!);
    }
  }

  Future<void> addOrder() async {
    if (hasMore) {
      ApiResponse apiResponse = await OrderRepository.getOldOrder(
          userID: _currentUserID,
          page: _currentPage + 1,
          shipOrderStatus: status,
          token: _currentToken);
      log(apiResponse.toString());
      if (apiResponse.isSuccess!) {
        List<Order> orders = apiResponse.dataResponse as List<Order>;
        _orders.addAll(orders.toList());
        if (orders.length < _limited) {
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
  Future<void> cancelOrder({
    required int orderID,
    required String reason,
    required String token,
    required Function onSuccess,
    required Function onFailed
  }) async {
    ApiResponse apiResponse=await OrderRepository.cancelOrder(orderID: orderID, reason: reason, token: token);
    if(apiResponse.isSuccess!){
      onSuccess();
    }else{
      onFailed(apiResponse.message!);
    }
  }
}