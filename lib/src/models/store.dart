class Store {
  int storeID;
  String storeName;
  String imagePath;
  String? firebaseID;

  Store(
      {required this.storeID,
      required this.storeName,
      required this.imagePath,
      this.firebaseID});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
        storeID: json['storeID'],
        storeName: json['storeName'],
        imagePath: json['imagepath'],
        firebaseID: json['firebaseID']
    );
  }

  @override
  String toString() {
    return 'Store{storeID: $storeID, storeName: $storeName, imagePath: $imagePath}';
  }
}
