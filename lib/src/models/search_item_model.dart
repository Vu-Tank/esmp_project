class SearchItemModel{
  String? search;
  double? minPrice;
  double? maxPrice;
  double? rate;
  int? cateID;
  int? subCateID;
  int? brandID;
  int? brandModelID;
  String? sortBy;
  double? la;
  double? lo;
  int? storeID;
  int page;

  SearchItemModel({
      this.search,
      this.minPrice,
      this.maxPrice,
      this.rate,
      this.cateID,
      this.subCateID,
      this.brandID,
      this.brandModelID,
      this.sortBy,
      this.la,
      this.lo,
      this.storeID,
      required this.page});

  // Map<String, dynamic> toJson() => {
  //   'search': search,
  //   'min': minPrice,
  //   'max': maxPrice,
  //   'rate': rate,
  //   'cateID': cateID,
  //   'subCateID': subCateID,
  //   'brandID': brandID,
  //   'brandModelID': brandModelID,
  //   'sortBy': sortBy,
  //   'la': la,
  //   'lo': lo,
  //   'storeID': storeID,
  //   'page': page
  // };
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['search']= search;
    data['min']= minPrice;
    data['max']= maxPrice;
    data['rate']= rate;
    data['cateID']= cateID;
    data['subCateID']= subCateID;
    data['brandID']= brandID;
    data['brandModelID']= brandModelID;
    data['sortBy']= sortBy;
    data['la']= la;
    data['lo']= lo;
    data['storeID']= storeID;
    data['page']= page;
    return data;
  }
  @override
  String toString() {
    return 'SearchItemModel{search: $search, minPrice: $minPrice, maxPrice: $maxPrice, rate: $rate, cateID: $cateID, subCateID: $subCateID, brandID: $brandID, brandModelID: $brandModelID, sortBy: $sortBy, la: $la, lo: $lo, storeID: $storeID, page: $page}';
  }
}