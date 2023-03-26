// ignore_for_file: public_member_api_docs, sort_constructors_first

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
        firebaseID: json['firebaseID']);
  }

  @override
  String toString() {
    return 'Store{storeID: $storeID, storeName: $storeName, imagePath: $imagePath}';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'storeID': storeID,
      'storeName': storeName,
      'imagePath': imagePath,
      'firebaseID': firebaseID,
    };
  }
}
