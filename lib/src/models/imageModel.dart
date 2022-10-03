class ImageModel{
  int? imageID;
  String? fileName;
  String? path;
  String? crete_date;
  bool? isActive;

  ImageModel({this.imageID, this.fileName, this.path, this.crete_date, this.isActive});

  factory ImageModel.fromJson(Map<String, dynamic> json){
    return ImageModel(
      imageID: json['imageID'] as int,
      fileName: json['fileName'] as String,
      path: json['path'] as String,
      crete_date: json['crete_date'] as String,
      isActive: json['isActive'] as bool,
    );
  }
}