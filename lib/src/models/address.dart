class AddressModel{
  int? addressID;
  String? context;
  String? province;
  String? district;
  String? ward;
  double? latitude;
  double? longitude;
  bool? isActive;

  AddressModel({this.addressID, this.context, this.province, this.district,
      this.ward, this.latitude, this.longitude, this.isActive});

  factory AddressModel.fromJson(Map<String, dynamic>json){
    return AddressModel(
        addressID: json['addressID'] as int,
        context: json['context'] as String,
        province: json['province'] as String,
        district: json['district'] as String,
        ward: json['ward'] as String,
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
        isActive: json['isActive'] as bool,
    );
  }
}
class GoogleAddress{
  String formatted_address;
  double lat;
  double lng;
  GoogleAddress({required this.formatted_address, required this.lat, required this.lng});

  factory GoogleAddress.fromJson(Map<String, dynamic>json){
    return GoogleAddress(
        formatted_address :json['formatted_address'] as String,
        lat: json['geometry']['location']['lat'],
        lng: json['geometry']['location']['lng']

    );
  }
}