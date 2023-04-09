import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/data_exchange.dart';
import 'package:esmp_project/src/repositoty/dataexchange_repository.dart';
import 'package:flutter/material.dart';

class DataExchangeProvider extends ChangeNotifier {
  List<DataExchange> _result = <DataExchange>[];
  List<DataExchange> get result => _result;
  int currentPage = 0;
  bool _hasMore = true;

  bool get hasMore => _hasMore;
  late int _currentUserID;
  late String _currentToken;

  Future<void> initData({required int userID, required String token}) async {
    _currentUserID = userID;
    _currentToken = token;
    ApiResponse apiResponse = await DataExchangeRepository.getDataExchange(
        userID: userID, token: token, page: 1);
    if (apiResponse.isSuccess!) {
      _result.clear();
      _result = apiResponse.dataResponse as List<DataExchange>;
      if (apiResponse.totalPage == 1) {
        _hasMore = false;
      } else {
        _hasMore = true;
      }

      if (_result.isNotEmpty) {
        currentPage = 1;
      }
      notifyListeners();
    } else {
      throw Exception(apiResponse.message!);
    }
  }

  Future<void> addData() async {
    ApiResponse apiResponse = await DataExchangeRepository.getDataExchange(
        userID: _currentUserID, page: currentPage + 1, token: _currentToken);
    if (apiResponse.isSuccess!) {
      List<DataExchange> service =
          apiResponse.dataResponse as List<DataExchange>;
      _result.addAll(service.toList());
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

  Future<void> getDataExchangeById(
      {required int userID,
      required String token,
      required int orderID}) async {
    _currentUserID = userID;
    _currentToken = token;
    ApiResponse apiResponse = await DataExchangeRepository.getDataExchange(
        userID: userID, token: token, page: 1, orderID: orderID);
    if (apiResponse.isSuccess!) {
      _result.clear();
      _result = apiResponse.dataResponse as List<DataExchange>;
      if (apiResponse.totalPage == 1) {
        _hasMore = false;
      } else {
        _hasMore = true;
      }

      if (_result.isNotEmpty) {
        currentPage = 1;
      }
      notifyListeners();
    } else {
      throw Exception(apiResponse.message!);
    }
  }
}
