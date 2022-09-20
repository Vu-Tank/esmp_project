class User{
  final int id;
  final String name;
  final String phone;
  final String imageUrl;
  final String gender;
  final String dateOfBirth;
  final String createDate;
  final int addressID;
  final int status;
  final String token;

  User({required this.id, required this.name, required this.phone, required this.imageUrl,
        required this.gender, required this.dateOfBirth, required this.status,
        required this.addressID, required this.createDate, required this.token});
  factory User.fromJson(Map<String, dynamic> json){
    return User(
        id: json['id'] as int,
        name: json['name'] as String,
        phone: json['phone'] as String,
        imageUrl: json['imageUrl'] as String,
        createDate: json['createDate'] as String,
        addressID: json['addressID'] as int,
        dateOfBirth: json['dateOfBirth'] as String,
        gender: json['gender'] as String,
        status: json['status'] as int,
        token: json['token'] as String,
    );
  }
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data=new Map<String, dynamic>();
    data['id']=this.id;
    data['name']=this.name;
    data['phone']=this.phone;
    data['imageUrl']=this.imageUrl;
    data['createDate']=this.createDate;
    data['addressID']=this.addressID;
    data['dateOfBirth']=this.dateOfBirth;
    data['gender']=this.gender;
    data['status']=this.status;
    return data;
  }
}