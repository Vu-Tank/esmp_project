import 'dart:developer';

import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/item.dart';
import 'package:esmp_project/src/repositoty/item_repository.dart';
import 'package:flutter/material.dart';

class ItemDetailProvider extends ChangeNotifier {
  late ItemDetail itemDetail;
  int _pageIndex = 1;
  final int _limit = 25;
  bool hasMore = true;
  Future<void> initItemDetail({required int itemId}) async {
    ApiResponse apiResponse = await ItemRepository.getItemDetail(itemId);
    if (apiResponse.isSuccess!) {
      itemDetail = apiResponse.dataResponse as ItemDetail;
      log(apiResponse.message!);
      _pageIndex = 1;

      notifyListeners();
    } else {
      throw Exception(apiResponse.message);
    }
  }
}
