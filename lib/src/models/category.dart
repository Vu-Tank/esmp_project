import 'package:esmp_project/src/models/subCategory.dart';

class Category {
  int categoryID;
  String name;
  List<SubCategory> listSub;

  Category(
      {required this.categoryID, required this.name, required this.listSub});

  factory Category.fromJson(Map<String, dynamic>json){
    return Category(
        categoryID: json['categoryID'],
        name: json['name'],
        listSub: (json['listSub'] as List).map((subCategory) => SubCategory.fromJson(subCategory)).toList());
  }

  @override
  String toString() {
    return 'Category{categoryID: $categoryID, name: $name, listSub: $listSub}';
  }
}