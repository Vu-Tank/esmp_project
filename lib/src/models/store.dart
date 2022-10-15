class Store {
  int storeID;
  String storeName;
  String imagePath;

  Store(
      {required this.storeID,
      required this.storeName,
      required this.imagePath});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
        storeID: json['storeID'],
        storeName: json['storeName'],
        imagePath: json['imagepath']);
  }

  @override
  String toString() {
    return 'Store{storeID: $storeID, storeName: $storeName, imagePath: $imagePath}';
  }
}
