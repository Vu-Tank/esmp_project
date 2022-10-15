class SpecificationItem {
  int specificationValueID;
  String value;
  int specificationID;
  String specificationName;

  SpecificationItem({required this.specificationValueID, required this.value,
    required this.specificationID, required this.specificationName});

  factory SpecificationItem.fromJson(Map<String, dynamic> json){
    return SpecificationItem(
        specificationValueID: json['specification_ValueID'],
        value: json['value'],
        specificationID: json['specificationID'],
        specificationName: json['specificationName']);
  }

  @override
  String toString() {
    return 'SpecificationItem{specificationValueID: $specificationValueID, value: $value, specificationID: $specificationID, specificationName: $specificationName}';
  }
}