class UserModel{
   int? userID;
   String? userName;
   String? email;
   String? phone;
   String? password;
   String? status;
   String? token;
   String? role;
   String? image;
   // int? user_AddressID;


   UserModel({ this.userID,  this.userName, this.email,  this.phone,this.password,
     this.status,  this.token,  this.role,  this.image});

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      userID: json['userID'] as int,
      userName: json['userName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
      status: json['status'] as String,
      token: json['token'] as String,
      role: json['role'] as String,
      image: json['image'] as String,
      // user_AddressID: json['user_AddressID'] as int,
    );
  }
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data=new Map<String, dynamic>();
    data['userID']=this.userID;
    return data;
  }
}