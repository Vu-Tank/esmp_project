import 'package:esmp_project/src/models/address.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/item.dart';
import 'package:esmp_project/src/models/motor.dart';
import 'package:esmp_project/src/models/search_item_model.dart';
import 'package:esmp_project/src/models/sort_model.dart';
import 'package:esmp_project/src/models/subCategory.dart';
import 'package:esmp_project/src/models/validation_item.dart';
import 'package:esmp_project/src/repositoty/brand_model_repository.dart';
import 'package:esmp_project/src/repositoty/category_repository.dart';
import 'package:esmp_project/src/repositoty/item_repository.dart';
import 'package:esmp_project/src/models/category.dart';
import 'package:esmp_project/src/utils/utils.dart';
import 'package:esmp_project/src/utils/validations.dart';
import 'package:flutter/material.dart';

import '../../models/motor_brand.dart';

class ItemsProvider extends ChangeNotifier {
  List<Item> _items = [];
  bool hasMore = true;
  int pageIndex = 0;
  bool isSearch = false;
  List<Item> get items => [..._items];

  void clearItem() {
    _items.clear();
    notifyListeners();
  }

  AddressModel? currentAddress;
  Future<ApiResponse> initItems() async {
    await Utils.determinePosition().then((value) {
      currentAddress =
          AddressModel(latitude: value.latitude, longitude: value.longitude);
    }).onError((error, stackTrace) => currentAddress = null);

    // log(address.toString());
    pageIndex = 1;
    SearchItemModel searchItemModel = getSearchModel();
    // searchItemModel.page=1;
    // log(searchItemModel.page.toString());
    ApiResponse apiResponse = await ItemRepository.searchItems(searchItemModel);
    if (apiResponse.isSuccess!) {
      _items.clear();
      _items = apiResponse.dataResponse as List<Item>;
      hasMore = true;
      notifyListeners();
    }
    return apiResponse;
  }

  final List<Category> _category = [];

  List<Category> get category => _category;
  Category selectedCategory =
      Category(categoryID: -1, name: "Tất cả", listSub: []);

  Future getCategory() async {
    if (_category.isEmpty) {
      ApiResponse apiResponse = await CategoryRepository.getCategory();
      if (apiResponse.isSuccess!) {
        _category.clear();
        _category.add(selectedCategory);
        _category.addAll(apiResponse.dataResponse as List<Category>);
        selectedCategory = _category.first;
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
    selectedCategory = value;
    if (value.categoryID != -1) {
      // xáo dropdown nạp lại dữ liệu
      _subCategory.clear();
      _subCategory.add(firstSubCategory);
      _subCategory.addAll(value.listSub);
      //reset select sub index == 0
      selectedSubCategory = firstSubCategory;
      // log(_subCategory.toString());
    } else {
      selectedSubCategory = firstSubCategory;
      _subCategory.clear();
    }
    notifyListeners();
  }

  void selectNewSubCategory(SubCategory value) {
    selectedSubCategory = value;
    // log(value.toString());
    notifyListeners();
  }

  final List<MotorBrand> _listMotorBrand = [];

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

  final List<Motor> _motor = [];

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
    // log(value.toString());
    notifyListeners();
  }

  final List<int> _ratings = [0, 1, 2, 3, 4, 5];

  List<int> get ratings => _ratings;
  int selectedrating = 0;

  void selectedNewRating(int value) {
    selectedrating = value;
    // log(value.toString());
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
  SortModel selectedSortModel = SortModel(name: "Gần nhất", query: '');

  void selectedNewSortModel(SortModel value) {
    selectedSortModel = value;
    // log(value.toString());
    notifyListeners();
  }

  double? minPrice;
  double? maxPrice;

  ValidationItem _minPriceValid = ValidationItem(null, null);

  ValidationItem get minPriceValid => _minPriceValid;

  bool validMinPrice(double minPrice) {
    // log(minPrice.toString());
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

  //reset
  void reset() {
    if (_category.isNotEmpty) selectNewCategory(_category.first);
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
    notifyListeners();
  }

  int? storeID;
  Future<void> getStoreID(int? value) async {
    storeID = value;
  }

  SearchItemModel getSearchModel() {
    return SearchItemModel(
      search: (txtSearch == null || txtSearch!.isEmpty) ? null : txtSearch,
      minPrice: minPrice,
      maxPrice: maxPrice,
      rate: double.parse(selectedrating.toString()),
      cateID: (selectedCategory.categoryID == -1)
          ? null
          : (selectedSubCategory.subCategoryID != -1)
              ? null
              : selectedCategory.categoryID,
      subCateID: (selectedSubCategory.subCategoryID == -1)
          ? null
          : selectedSubCategory.subCategoryID,
      brandID: (selectedMotorBrand.brandID == -1)
          ? null
          : (seletedMotor.motorId != -1)
              ? null
              : selectedMotorBrand.brandID,
      brandModelID: (seletedMotor.motorId == -1) ? null : seletedMotor.motorId,
      la: (address != null) ? address!.latitude : currentAddress?.latitude,
      // la: (selectedSortModel.query.isNotEmpty)?null:(address!=null)? address!.latitude: currentAddrress?.latitude,
      lo: (address != null) ? address!.longitude : currentAddress?.longitude,
      // lo: (selectedSortModel.query.isNotEmpty)?null:(address!=null)? address!.longitude: currentAddrress?.longitude,
      sortBy: (selectedSortModel.name.compareTo("Tất cả") == 0)
          ? null
          : selectedSortModel.query,
      storeID: storeID,
      page: pageIndex,
    );
  }

  Future<void> applySearch() async {
    SearchItemModel searchItemModel = getSearchModel();
    searchItemModel.page = 1;
    ApiResponse apiResponse = await ItemRepository.searchItems(searchItemModel);

    if (apiResponse.isSuccess!) {
      _items.clear();
      _items = apiResponse.dataResponse as List<Item>;
      pageIndex = searchItemModel.page;
      if (_items.length < 6) {
        hasMore = false;
      } else {
        hasMore = true;
      }
      notifyListeners();
    } else {
      throw Exception(apiResponse.message);
    }
  }

  Future<void> addItem() async {
    SearchItemModel searchItemModel = getSearchModel();
    searchItemModel.page = pageIndex + 1;
    ApiResponse apiResponse = await ItemRepository.addItems(searchItemModel);
    if (apiResponse.isSuccess!) {
      List<Item> items = apiResponse.dataResponse as List<Item>;
      _items.addAll(items.toList());
      if (items.isEmpty) {
        hasMore = false;
      } else {
        hasMore = true;
      }
      if (items.isNotEmpty) pageIndex++;
      notifyListeners();
    }
  }
}
