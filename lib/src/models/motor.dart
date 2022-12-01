class Motor{
  int motorId;
  String name;
  bool isActive;

  Motor({required this.motorId,required this.name,required this.isActive});
  factory Motor.fromJson(Map<String, dynamic> json){
    return Motor(motorId: json['brand_ModelID'], name: json['name'], isActive: json['isActive']);
  }

  @override
  String toString() {
    // return 'Motor{motorId: $motorId, name: $name, isActive: $isActive}';
    return name;
  }
}