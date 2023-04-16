import 'dart:developer';

import 'package:esmp_project/src/models/address.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/repositoty/order_repository.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/order.dart';
import '../../repositoty/payment_repository.dart';

class ShoppingCartProvider extends ChangeNotifier {
  List<Order>? _order = [];

  List<Order>? get order => _order;

  void loadingData(List<Order>? data) {
    _order = data;
    selectedOrder = null;
    notifyListeners();
  }

  Future<void> loadData({required int userId, required String token}) async {
    ApiResponse apiResponse =
        await OrderRepository.loadingOrder(userId: userId, token: token);
    if (apiResponse.isSuccess!) {
      _order?.clear();
      _order = apiResponse.dataResponse as List<Order>;
      selectedIndex = -1;
      notifyListeners();
    } else {
      throw Exception(apiResponse.message!);
    }
  }

  // void selectedStore(int index) {
  //   _order![index].isSeleted = !_order![index].isSeleted;
  //   notifyListeners();
  // }

  int selectedIndex = -1;
  Order? selectedOrder;

  void selectOrderToPay(int value) {
    selectedIndex = value;
    notifyListeners();
  }

  Future<void> updateSelectedOrder(AddressModel address, String token) async {
    if (selectedOrder != null) {
      ApiResponse apiResponse = await OrderRepository.updateAddressOrder(
          orderID: selectedOrder!.orderID,
          addressID: address.addressID!,
          token: token);
      if (apiResponse.isSuccess!) {
        selectedOrder = apiResponse.dataResponse as Order;
        notifyListeners();
      } else {
        throw Exception(apiResponse.message!);
      }
    }
  }

  Future<void> addAmount(int indexOrder, int indexSubItemID, String token,
      Function onFailed) async {
    // _order![indexOrder].details[indexsubItemID].amount=_order![indexOrder].details[indexsubItemID].amount+1;
    ApiResponse apiResponse = await OrderRepository.updateAmountOrder(
        token: token,
        orderDetailID:
            _order![indexOrder].details[indexSubItemID].orderDetailID,
        amount: _order![indexOrder].details[indexSubItemID].amount + 1);
    if (apiResponse.isSuccess!) {
      _order![indexOrder].details[indexSubItemID].amount =
          apiResponse.dataResponse as int;
      notifyListeners();
    } else {
      onFailed(apiResponse.message);
    }
  }

  Future<void> subtractAmount(int indexOrder, int indexSubItemID, String token,
      Function onFailed) async {
    int amount = _order![indexOrder].details[indexSubItemID].amount;
    ApiResponse apiResponse = ApiResponse();
    if (amount == 1) {
      if (_order![indexOrder].details.length == 1) {
        apiResponse = await OrderRepository.removeOrder(
            token: token, orderID: _order![indexOrder].orderID);
      } else {
        apiResponse = await OrderRepository.removeOrderDetail(
            token: token,
            orderDetailID:
                _order![indexOrder].details[indexSubItemID].orderDetailID);
      }
    } else {
      apiResponse = await OrderRepository.updateAmountOrder(
          token: token,
          orderDetailID:
              _order![indexOrder].details[indexSubItemID].orderDetailID,
          amount: _order![indexOrder].details[indexSubItemID].amount - 1);
    }
    if (apiResponse.isSuccess!) {
      if (amount == 1) {
        if (_order![indexOrder].details.length == 1) {
          _order!.removeAt(indexOrder);
        } else {
          _order![indexOrder] = apiResponse.dataResponse as Order;
        }
      } else {
        _order![indexOrder].details[indexSubItemID].amount =
            apiResponse.dataResponse as int;
      }
      notifyListeners();
    } else {
      onFailed(apiResponse.message);
    }
  }

  Future<void> deleteSubItem(int indexOrder, int indexSubItemID, String token,
      Function onFailed, Function onSuccess) async {
    ApiResponse apiResponse = ApiResponse();
    if (_order![indexOrder].details.length == 1) {
      apiResponse = await OrderRepository.removeOrder(
          token: token, orderID: _order![indexOrder].orderID);
    } else {
      apiResponse = await OrderRepository.removeOrderDetail(
          token: token,
          orderDetailID:
              _order![indexOrder].details[indexSubItemID].orderDetailID);
    }
    if (apiResponse.isSuccess!) {
      if (_order![indexOrder].details.length == 1) {
        _order!.removeAt(indexOrder);
      } else {
        _order![indexOrder] = apiResponse.dataResponse as Order;
      }
      onSuccess();
      notifyListeners();
    } else {
      onFailed(apiResponse.message);
    }
  }

  Future<void> payment(
      {required String token,
      required Function onFailed,
      required Function onSuccess,
      required String paymentMethod}) async {
    //MOMO, COD
    ApiResponse apiResponse = await PaymentRepository.paymentOrder(
        orderID: selectedOrder!.orderID,
        token: token,
        paymentMethod: paymentMethod);
    if (apiResponse.isSuccess!) {
      final url = Uri.parse(apiResponse.dataResponse as String);
      log(url.toString());
      try {
        onSuccess();
        if (paymentMethod == "MOMO") {
          await launchUrl(url);
        }
      } on Exception catch (e) {
        // TODO
        onFailed(e.toString());
      }
    } else {
      onFailed(apiResponse.message!);
    }
  }

  Future<void> getOrderToPay(
      {required String token, required int orderID}) async {
    ApiResponse apiResponse =
        await OrderRepository.getOrder(orderID: orderID, token: token);
    if (apiResponse.isSuccess!) {
      selectedOrder = apiResponse.dataResponse as Order;
      notifyListeners();
    } else {
      throw Exception(apiResponse.message);
    }
  }

  Future<void> addAmountWhenPayment(int orderID, int orderDetatailID, int index,
      String token, Function onFailed) async {
    // _order![indexOrder].details[indexsubItemID].amount=_order![indexOrder].details[indexsubItemID].amount+1;
    ApiResponse apiResponse = await OrderRepository.updateAmountOrder(
        token: token,
        orderDetailID: orderDetatailID,
        amount: selectedOrder!.details[index].amount + 1);
    if (apiResponse.isSuccess!) {
      // apiResponse =
      //     await OrderRepository.getOrder(orderID: orderID, token: token);
      // if (apiResponse.isSuccess!) {
      //   selectedOrder = apiResponse.dataResponse as Order;
      //   notifyListeners();
      // } else {
      //   throw Exception(apiResponse.message);
      // }
      selectedOrder!.details[index].amount = apiResponse.dataResponse as int;
      double price = 0;
      for (var element in selectedOrder!.details) {
        price = price +
            (element.pricePurchase * (1 - element.discountPurchase)) *
                element.amount;
      }
      selectedOrder!.priceItem = price;
      notifyListeners();
    } else {
      onFailed(apiResponse.message);
    }
  }

  Future<void> subtractAmountWhenPayment(int orderID, int orderDetatailID,
      int index, String token, Function onFailed) async {
    int amount = selectedOrder!.details[index].amount;
    ApiResponse apiResponse = ApiResponse();
    if (amount == 1) {
      if (selectedOrder!.details.length == 1) {
        apiResponse = await OrderRepository.removeOrder(
            token: token, orderID: selectedOrder!.orderID);
      } else {
        apiResponse = await OrderRepository.removeOrderDetail(
            token: token, orderDetailID: orderDetatailID);
      }
    } else {
      apiResponse = await OrderRepository.updateAmountOrder(
          token: token,
          orderDetailID: orderDetatailID,
          amount: selectedOrder!.details[index].amount - 1);
    }
    if (apiResponse.isSuccess!) {
      if (amount == 1) {
        if (selectedOrder!.details.length == 1) {
          selectedOrder = null;
        } else {
          selectedOrder = apiResponse.dataResponse as Order;
        }
      } else {
        selectedOrder!.details[index].amount = apiResponse.dataResponse as int;
        double price = 0;
        for (var element in selectedOrder!.details) {
          price = price +
              (element.pricePurchase * (1 - element.discountPurchase)) *
                  element.amount;
        }
        selectedOrder!.priceItem = price;
      }
      notifyListeners();
    } else {
      onFailed(apiResponse.message);
    }
  }
}
