import 'dart:developer';

import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/item.dart';
import 'package:esmp_project/src/repositoty/item_repository.dart';
import 'package:flutter/material.dart';

class ItemsProvider extends ChangeNotifier{
  // late List<Item> _items= [
  //   Item(
  //       itemID: 0,
  //       name: 'Bonamici - Bảo vệ đồng hồ Aprilia RSV4 2022',
  //       description: 'Bonamici - Bảo vệ đồng hồ Aprilia RSV4 2022',
  //       discount: 15,
  //       rate: 0,
  //       price: 4300000,
  //       itemImage:
  //       'https://www.tinomotor.vn/storage/pagedata/100113/img/images/product/3413_DCP13__25507.1635193400.png',
  //       province: 'Hà Nội'),
  //   Item(
  //       itemID: 0,
  //       name: 'Bonamici - Bảo vệ đồng hồ Aprilia RSV4 2022',
  //       description: 'Bonamici - Bảo vệ đồng hồ Aprilia RSV4 2022',
  //       discount: 15,
  //       rate: 0,
  //       price: 4300000,
  //       itemImage:
  //       'https://www.tinomotor.vn/storage/pagedata/100113/img/images/product/3413_DCP13__25507.1635193400.png',
  //       province: 'Hà Nội'),
  //   Item(
  //       itemID: 0,
  //       name: 'Bonamici - Bảo vệ đồng hồ Aprilia RSV4 2022',
  //       description: 'Bonamici - Bảo vệ đồng hồ Aprilia RSV4 2022',
  //       discount: 15,
  //       rate: 0,
  //       price: 4300000,
  //       itemImage:
  //       'https://www.tinomotor.vn/storage/pagedata/100113/img/images/product/3413_DCP13__25507.1635193400.png',
  //       province: 'Hà Nội'),
  //   Item(
  //       itemID: 0,
  //       name: 'Bonamici - Bảo vệ đồng hồ Aprilia RSV4 202299999999999999999999999999999999999999999999999999999999999999',
  //       description: 'Bonamici - Bảo vệ đồng hồ Aprilia RSV4 2022',
  //       discount: 15,
  //       rate: 0,
  //       price: 4300000,
  //       itemImage:
  //       'https://www.tinomotor.vn/storage/pagedata/100113/img/images/product/3413_DCP13__25507.1635193400.png',
  //       province: 'Hà Nội'),
  // ];
  List<Item> _items=[];


  List<Item> get items => [..._items];

  Item findById(int id){
    return _items.firstWhere((element) => element.itemID==id);
  }
  Future<ApiResponse> initItems() async{
    ApiResponse apiResponse=await ItemRepository.getItems(1);
    if(apiResponse.isSuccess!){
      _items=apiResponse.dataResponse as List<Item>;
      notifyListeners();
    }
    return apiResponse;
  }
}