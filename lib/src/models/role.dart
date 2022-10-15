class Role{
  int? roleID;
  String? roleName;
  bool? isActive;

  Role({this.roleID, this.isActive, this.roleName});

  factory Role.fromJson(Map<String, dynamic> json){
    return Role(
      roleID: json['roleID'] as int,
      roleName: json['roleName'] as String,
      isActive: json['isActive'] as bool,
    );
  }

  @override
  String toString() {
    return 'Role{roleID: $roleID, roleName: $roleName, isActive: $isActive}';
  }
}