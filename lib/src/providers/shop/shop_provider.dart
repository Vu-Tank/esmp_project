import 'dart:developer';

import 'package:esmp_project/src/models/Motor_brand.dart';
import 'package:esmp_project/src/models/address.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/category.dart';
import 'package:esmp_project/src/models/item.dart';
import 'package:esmp_project/src/models/motor.dart';
import 'package:esmp_project/src/models/search_item_model.dart';
import 'package:esmp_project/src/models/sort_model.dart';
import 'package:esmp_project/src/models/subCategory.dart';
import 'package:esmp_project/src/models/validation_item.dart';
import 'package:esmp_project/src/repositoty/brand_model_repository.dart';
import 'package:esmp_project/src/repositoty/category_repository.dart';
import 'package:esmp_project/src/repositoty/item_repository.dart';
import 'package:esmp_project/src/utils/validations.dart';
import 'package:flutter/material.dart';

class StoreProvider extends ChangeNotifier {
  int? storeID;
  List<Item> _items = [];
  bool hasMore = true;
  final int limit = 25;
  int pageIndex = 0;

  List<Item> get items => [..._items];

  List<Category> _category = [];

  List<Category> get category => _category;
  Category selectedCategoty =
      Category(categoryID: -1, name: "Tất cả", listSub: []);

  Future getCategory() async {
    if (_category.isEmpty) {
      ApiResponse apiResponse = await CategoryRepository.getCategory();
      if (apiResponse.isSuccess!) {
        _category.clear();
        _category.add(selectedCategoty);
        _category.addAll(apiResponse.dataResponse as List<Category>);
        selectedCategoty = _category.first;
        notifyListeners();
      } else {
        throw Exception(apiResponse.message);
      }
    }
  }

  final List<SubCategory> _subCategory = [];

  List<SubCategory> get subCategory => _subCategory;
  SubCategory firstSubCategory =
      SubCategory(subCategoryID: -1, subcategoryName: "Tất cả");
  SubCategory selectedSubCategory =
      SubCategory(subCategoryID: -1, subcategoryName: "Tất cả");

  void selectNewCategory(Category value) {
    selectedCategoty = value;
    if (value.categoryID != -1) {
      // xáo dropdown nạp lại dữ liệu
      _subCategory.clear();
      _subCategory.add(firstSubCategory);
      _subCategory.addAll(value.listSub);
      //reset select sub index == 0
      selectedSubCategory = firstSubCategory;
      log(_subCategory.toString());
    } else {
      selectedSubCategory = firstSubCategory;
      _subCategory.clear();
    }
    notifyListeners();
  }

  void selectNewSubCategory(SubCategory value) {
    selectedSubCategory = value;
    log(value.toString());
    notifyListeners();
  }

  List<MotorBrand> _listMotorBrand = [];

  List<MotorBrand> get listMotorBrand => _listMotorBrand;
  MotorBrand selectedMotorBrand =
      MotorBrand(brandID: -1, name: "Tất cả", isActive: true, listMotor: []);

  Future getMotorBrand() async {
    if (_listMotorBrand.isEmpty) {
      ApiResponse apiResponse = await BrandModelRepository.getMotorBrand();
      // log(apiResponse.toString());
      if (apiResponse.isSuccess!) {
        _listMotorBrand.add(selectedMotorBrand);
        _listMotorBrand.addAll(apiResponse.dataResponse as List<MotorBrand>);
        // log(_listMotorBrand.toString());
        notifyListeners();
      } else {
        throw Exception(apiResponse.message);
      }
    }
  }

  List<Motor> _motor = [];

  List<Motor> get motor => _motor;
  Motor firstMotor = Motor(motorId: -1, name: "Tất cả", isActive: true);
  Motor seletedMotor = Motor(motorId: -1, name: "Tất cả", isActive: true);

  void selectedNewMotorBrand(MotorBrand motorBrand) {
    selectedMotorBrand = motorBrand;
    if (motorBrand.brandID != -1) {
      _motor.clear();
      _motor.add(firstMotor);
      _motor.addAll(motorBrand.listMotor);
      seletedMotor = _motor.first;
    } else {
      seletedMotor = firstMotor;
      _motor.clear();
    }
    notifyListeners();
  }

  void selectedNewMotor(Motor value) {
    seletedMotor = value;
    log(value.toString());
    notifyListeners();
  }

  final List<int> _ratings = [0, 1, 2, 3, 4, 5];

  List<int> get ratings => _ratings;
  int selectedrating = 0;

  void selectedNewRating(int value) {
    selectedrating = value;
    log(value.toString());
    notifyListeners();
  }

  final List<SortModel> _listSortModel = [];
  Future<void> initSortModel() async {
    if (_listSortModel.isEmpty) {
      _listSortModel.add(selectedSortModel);
      _listSortModel.add(SortModel(name: "Giá tăng dần", query: 'price_asc'));
      _listSortModel.add(SortModel(name: "Giá giảm dần", query: 'price_desc'));
      _listSortModel.add(SortModel(name: "Giảm giá", query: 'discount'));
    }
  }

  List<SortModel> get listSortModel => _listSortModel;
  SortModel selectedSortModel = SortModel(name: "Tất cả", query: '');

  void selectedNewSortModel(SortModel value) {
    selectedSortModel = value;
    log(value.toString());
    notifyListeners();
  }

  double? minPrice;
  double? maxPrice;

  ValidationItem _minPriceValid = ValidationItem(null, null);

  ValidationItem get minPriceValid => _minPriceValid;

  bool validMinPrice(double minPrice) {
    log(minPrice.toString());
    minPrice = minPrice;
    _minPriceValid = Validations.valMinPrice(minPrice, maxPrice);
    // log(_minPriceValid.error!);
    if (_minPriceValid.error != null) {
      notifyListeners();
      return false;
    }
    notifyListeners();
    return true;
  }

  ValidationItem _maxPriceValid = ValidationItem(null, null);

  ValidationItem get maxPriceValid => _maxPriceValid;
  bool validMaxPrice(double maxPrice) {
    maxPrice = maxPrice;
    _minPriceValid = Validations.valMaxPrice(minPrice, maxPrice);
    if (_minPriceValid.error != null) {
      notifyListeners();
      return false;
    }
    notifyListeners();
    return true;
  }

  AddressModel? address;
  void selectedAddress(AddressModel? value) {
    address = value;
    notifyListeners();
  }

  String? txtSearch;
  Future<void> getTxtSearch(String? value) async {
    txtSearch = value;
    // notifyListeners();
  }

  //reset
  void reset() {
    if (_category.isNotEmpty) (_category.first);
    if (_listMotorBrand.isNotEmpty) {
      selectedNewMotorBrand(_listMotorBrand.first);
    }
    selectedNewRating(0);
    if (_listSortModel.isNotEmpty) selectedNewSortModel(_listSortModel.first);
    minPrice = null;
    maxPrice = null;
    _minPriceValid = ValidationItem(null, null);
    _maxPriceValid = ValidationItem(null, null);
    address = null;
    _items.clear();
    notifyListeners();
  }

  Future<void> getStoreID(int? value) async {
    storeID = value;
  }

  SearchItemModel getSearchModel() {
    return SearchItemModel(
      search: (txtSearch == null || txtSearch!.isEmpty) ? null : txtSearch,
      minPrice: minPrice,
      maxPrice: maxPrice,
      rate: double.parse(selectedrating.toString()),
      cateID: (selectedCategoty.categoryID == -1)
          ? null
          : (selectedSubCategory.subCategoryID != -1)
              ? null
              : selectedCategoty.categoryID,
      subCateID: (selectedSubCategory.subCategoryID == -1)
          ? null
          : selectedSubCategory.subCategoryID,
      brandID: (selectedMotorBrand.brandID == -1)
          ? null
          : (seletedMotor.motorId != -1)
              ? null
              : selectedMotorBrand.brandID,
      brandModelID: (seletedMotor.motorId == -1) ? null : seletedMotor.motorId,
      la: address?.latitude,
      lo: address?.longitude,
      sortBy: (selectedSortModel.name.compareTo("Tất cả") == 0)
          ? null
          : selectedSortModel.query,
      storeID: storeID,
      page: pageIndex,
    );
  }

  Future<void> applySearch() async {
    pageIndex = 1;
    SearchItemModel searchItemModel = getSearchModel();
    // searchItemModel.page=1;
    ApiResponse apiResponse = await ItemRepository.searchItems(searchItemModel);
    if (apiResponse.isSuccess!) {
      _items = apiResponse.dataResponse as List<Item>;
      log(limit.toString());
      pageIndex = searchItemModel.page;
      if (_items.length < limit) {
        hasMore = false;
      } else {
        hasMore = true;
      }
      log(hasMore.toString());
      notifyListeners();
    } else {
      throw Exception(apiResponse.message);
    }
  }

  Future<void> addItemSearch() async {
    if (hasMore) {
      pageIndex++;
      SearchItemModel searchItemModel = getSearchModel();
      ApiResponse apiResponse =
          await ItemRepository.searchItems(searchItemModel);
      if (apiResponse.isSuccess!) {
        List<Item> items=apiResponse.dataResponse as List<Item>;
        _items.addAll(items);
        log(_items.toString());
        pageIndex = searchItemModel.page;
        if (items.length < limit) {
          hasMore = false;
        } else {
          hasMore = true;
        }
        if(items.isEmpty){
          pageIndex--;
        }
        notifyListeners();
      } else {
        throw Exception(apiResponse.message);
      }
    }
  }
}
