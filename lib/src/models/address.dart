
import 'package:esmp_project/src/repositoty/address_repository.dart';

class AddressModel {
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

  AddressModel(
      {this.addressID,
      this.context,
      this.province,
      this.district,
      this.ward,
      this.userName,
      this.userPhone,
      this.latitude,
      this.longitude,
      this.isActive});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
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

class GoogleAddress {
  String formattedAddress;
  double lat;
  double lng;

  GoogleAddress(
      {required this.formattedAddress, required this.lat, required this.lng});

  factory GoogleAddress.fromJson(Map<String, dynamic> json) {
    return GoogleAddress(
        formattedAddress: json['formatted_address'] as String,
        lat: json['geometry']['location']['lat'] as double,
        lng: json['geometry']['location']['lng'] as double);
  }

  @override
  String toString() {
    return 'GoogleAddress{formattedAddress: $formattedAddress, lat: $lat, lng: $lng}';
  }
}

class Province {
  String name;
  String slug;
  String type;
  String name_with_type;
  String code;
  List<District> listDistrict;

  Province(
      {required this.name,
      required this.slug,
      required this.type,
      required this.name_with_type,
      required this.code,
      required this.listDistrict});

  static Future<Province> fromJson(Map<String, dynamic> json) async {
    String code = json['code'];
    List<District> listDistrict = await AddressRepository.getDistrict(code);
    // log(listDistrict.toString());
    return Province(
      name: json['name'],
      slug: json['slug'],
      type: json['type'],
      name_with_type: json['name_with_type'],
      code: json['code'],
      listDistrict: listDistrict,
    );
  }

  @override
  String toString() {
    return 'Province{name: $name, slug: $slug, type: $type, name_with_type: $name_with_type, code: $code, listDistrict: $listDistrict}';
  }
}

class District {
  String name;
  String type;
  String name_with_type;
  String code;
  String path_with_type;
  List<Ward> listWard;
  District(
      {required this.name,
      required this.type,
      required this.name_with_type,
      required this.code,
      required this.path_with_type,
      required this.listWard
      });

  static Future<District> fromJson(Map<String, dynamic> json)async {
    String districtCode=json['code'];
    List<Ward> listWard=await AddressRepository.getWard(districtCode);
    // log(listWard.length.toString());
    return District(
        name: json['name'],
        type: json['type'],
        name_with_type: json['name_with_type'],
        code: json['code'],
        path_with_type: json['path_with_type'],
        listWard: listWard,
    );
  }

  @override
  String toString() {
    return 'District{name: $name, type: $type, name_with_type: $name_with_type, code: $code, path_with_type: $path_with_type, listWard: $listWard}';
  }
}

class Ward {
  String name;
  String type;
  String name_with_type;
  String path_with_type;
  String code;

  Ward(
      {required this.name,
      required this.type,
      required this.name_with_type,
      required this.path_with_type,
      required this.code});

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
        name: json['name'],
        type: json['type'],
        name_with_type: json['name_with_type'],
        path_with_type: json['path_with_type'],
        code: json['code']);
  }

  @override
  String toString() {
    return 'Ward{name: $name, type: $type, name_with_type: $name_with_type, path_with_type: $path_with_type, code: $code}';
  }
}
