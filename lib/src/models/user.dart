import 'package:esmp_project/src/models/address.dart';
import 'package:esmp_project/src/models/imageModel.dart';
import 'package:esmp_project/src/models/role.dart';

class UserModel{
   int? userID;
   String? userName;
   String? email;
   String? phone;
   // String? password;
   String? dateOfBirth;
   String? gender;
   String? creteDate;
   bool? isActive;
   String? token;
   Role? role;
   ImageModel? image;
   List<AddressModel>? address;


   UserModel({
      this.userID,
      this.userName,
      this.email,
      this.phone,
      // this.password,
      this.dateOfBirth,
      this.gender,
      this.creteDate,
      this.isActive,
      this.token,
      this.role,
      this.image,
      this.address});

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      userID: json['userID'] as int ,
      userName: json['userName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      // password: json['password'] as String?,
      dateOfBirth: json['dateOfBirth'] as String,
      gender: json['gender'] as String,
      creteDate: json['crete_date'] as String,
      isActive: json['isActive'] as bool,
      token: json['token'] as String,
      role: Role.fromJson(json['role']),
      image: ImageModel.fromJson(json['image']),
      address: (json['addresses'] as List).map((model) => AddressModel.fromJson(model)).toList(),
    );
  }
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data=<String, dynamic>{};
    data['userName']=userName;
    data['email']=email;
    data['phone']=phone;
    data['imageName']=image?.fileName;
    data['imagepath']=image!.path;
    data['contextAddress']=address?[0].context;
    data['dateOfBirth']=dateOfBirth;
    data['gender']=gender;
    data['latitude']=address![0].latitude;
    data['longitude']=address![0].longitude;
    data['province']=address![0].province;
    data['district']=address![0].district;
    data['ward']=address![0].ward;
    return data;
  }

   @override
  String toString() {
    return 'UserModel{userID: $userID, userName: $userName, email: $email, phone: $phone, dateOfBirth: $dateOfBirth, gender: $gender, crete_date: $creteDate, isActive: $isActive, token: $token, role: $role, image: $image, address: $address}';
  }
}