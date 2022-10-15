import 'package:esmp_project/src/models/motor.dart';

class MotorBrand {
  int brandID;
  String name;
  bool isActive;
  List<Motor> listMotor;

  MotorBrand(
      {required this.brandID, required this.name, required this.isActive, required this.listMotor});

  factory MotorBrand.fromJson(Map<String, dynamic> json){
    return MotorBrand(brandID: json['brandID'],
        name: json['name'],
        isActive: json['isActive'],
        listMotor: (json['listModel'] as List).map((motor) => Motor.fromJson(motor)).toList());
  }

  @override
  String toString() {
    return 'MotorBrand{brandID: $brandID, name: $name, isActive: $isActive, listMotor: $listMotor}';
  }
}