class SubCategory {
  int subCategoryID;
  String subcategoryName;

  SubCategory({required this.subCategoryID, required this.subcategoryName});

  factory SubCategory.fromJson(Map<String, dynamic>json){
    return SubCategory(subCategoryID: json['sub_CategoryID'], subcategoryName: json['sub_categoryName']);
  }

  @override
  String toString() {
    return 'SubCategory{subCategoryID: $subCategoryID, subcategoryName: $subcategoryName}';
  }
}