import 'dart:developer';

import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/sub_item.dart';
import 'package:esmp_project/src/repositoty/order_repository.dart';
import 'package:flutter/material.dart';

class ItemProvider extends ChangeNotifier {
  SubItem? subItem;

  void initSubItem(SubItem sItem) {
    amount = 1;
    subItem = sItem;
  }

  void selectedSubItem(SubItem sItem) {
    subItem = sItem;
    amount = 1;
    notifyListeners();
  }

  int amount = 1;

  void add() {
    if (amount < subItem!.amount) {
      amount++;
    }
    notifyListeners();
  }

  void subtract() {
    if (amount > 0) {
      amount--;
    }
    notifyListeners();
  }

  Future<void> addToCart(
      {required Function onSucces,
      required Function onFailed,
      required int userID,
      required String token}) async {
    if (subItem == null) {
      onFailed("Vui Lòng chọn loại sản phẩm");
      return;
    }
    if (amount <= 0) {
      onFailed("Số lượng ít nhất là một");
      return;
    }
    log(subItem!.subItemID.toString());
    ApiResponse apiResponse = await OrderRepository.createOder(
        userID: userID,
        amount: amount,
        subItemID: subItem!.subItemID,
        token: token);
    if (apiResponse.isSuccess!) {
      onSucces(apiResponse.message!);
    } else {
      onFailed(apiResponse.message!);
    }
  }
}
