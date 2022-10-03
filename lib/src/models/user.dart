import 'package:esmp_project/src/models/address.dart';
import 'package:esmp_project/src/models/imageModel.dart';
import 'package:esmp_project/src/models/role.dart';

class UserModel{
   int? userID;
   String? userName;
   String? email;
   String? phone;
   String? password;
   String? dateOfBirth;
   String? gender;
   String? crete_date;
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
      this.password,
      this.dateOfBirth,
      this.gender,
      this.crete_date,
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
      password: json['password'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      gender: json['gender'] as String,
      crete_date: json['crete_date'] as String,
      isActive: json['isActive'] as bool,
      token: json['token'] as String,
      role: Role.fromJson(json['role']),
      image: ImageModel.fromJson(json['image']),
      address: (json['addresses'] as List).map((model) => AddressModel.fromJson(model)).toList(),
    );
  }
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data=new Map<String, dynamic>();
    data['userID']=this.userID;
    return data;
  }
}