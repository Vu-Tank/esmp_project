class AddressModel{
  int? addressID;
  String? context;
  String? province;
  String? district;
  String? ward;
  String? userName;
  String? userPhone;
  double? latitude;
  double? longitude;
  bool? isActive;

  AddressModel({this.addressID, this.context, this.province, this.district,
      this.ward,this.userName,this.userPhone, this.latitude, this.longitude, this.isActive});

  factory AddressModel.fromJson(Map<String, dynamic>json){
    return AddressModel(
        addressID: json['addressID'] as int,
        context: json['context'] as String,
        province: json['province'] as String,
        district: json['district'] as String,
        ward: json['ward'] as String,
        userName: json['userName'] as String,
        userPhone: json['phone'],
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
        isActive: json['isActive'] as bool,
    );
  }

  @override
  String toString() {
    return 'AddressModel{addressID: $addressID, context: $context, province: $province, district: $district, ward: $ward, userName: $userName, userPhone: $userPhone, latitude: $latitude, longitude: $longitude, isActive: $isActive}';
  }
}
class GoogleAddress{
  String formattedAddress;
  double lat;
  double lng;
  GoogleAddress({required this.formattedAddress, required this.lat, required this.lng});

  factory GoogleAddress.fromJson(Map<String, dynamic>json){
    return GoogleAddress(
        formattedAddress :json['formatted_address'] as String,
        lat: json['geometry']['location']['lat'] as double,
        lng: json['geometry']['location']['lng'] as double

    );
  }

  @override
  String toString() {
    return 'GoogleAddress{formattedAddress: $formattedAddress, lat: $lat, lng: $lng}';
  }
}