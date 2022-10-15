class ImageModel{
  int? imageID;
  String? fileName;
  String? path;
  String? creteDate;
  bool? isActive;

  ImageModel({this.imageID, this.fileName, this.path, this.creteDate, this.isActive});

  factory ImageModel.fromJson(Map<String, dynamic> json){
    return ImageModel(
      imageID: json['imageID'] as int,
      fileName: json['fileName'] as String,
      path: json['path'] as String,
      creteDate: json['crete_date'] as String,
      isActive: json['isActive'] as bool,
    );
  }
  @override
  String toString() {
    return 'ImageModel{imageID: $imageID, fileName: $fileName, path: $path, crete_date: $creteDate, isActive: $isActive}';
  }
}