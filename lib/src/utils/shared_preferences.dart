import 'package:esmp_project/src/models/imageModel.dart';
import 'package:esmp_project/src/models/role.dart';
import 'package:esmp_project/src/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  Future<bool> saveUser(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("userID", user.userID!);
    prefs.setString("userName", user.userName!);
    prefs.setString("email", user.email!);
    prefs.setString("phone", user.phone!);
    prefs.setString("password", user.password!);
    prefs.setString("dateOfBirth", user.dateOfBirth!);
    prefs.setString("gender", user.gender!);
    prefs.setString("crete_date", user.crete_date!);
    prefs.setBool("isActive", user.isActive!);
    prefs.setInt("roleID", user.role!.roleID!);
    prefs.setString("image_path", user.image!.path!);
    prefs.setString("token", user.token!);

    return prefs.commit();
  }

  Future<UserModel> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userID = prefs.getInt("userID");
    String? userName = prefs.getString("userName");
    String? email = prefs.getString("email");
    String? phone = prefs.getString("phone");
    String? password = prefs.getString("password");
    String? dateOfBirth = prefs.getString("dateOfBirth");
    String? gender = prefs.getString("gender");
    String? crete_date = prefs.getString("crete_date");
    bool? isActive = prefs.getBool("isActive");
    int? roleID = prefs.getInt("roleID");
    String? image_path = prefs.getString("image_path");
    String? token = prefs.getString("token");
    return UserModel(
      userID: userID!,
      userName: userName!,
      email: email!,
      phone: phone!,
      password: password!,
      dateOfBirth: dateOfBirth!,
      gender: gender!,
      crete_date: crete_date!,
      isActive: isActive,
      token: token,
      role: Role(roleID: roleID),
      image: ImageModel(path: image_path),
    );
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userID");
    prefs.remove("userName");
    prefs.remove("email");
    prefs.remove("phone");
    prefs.remove("password");
    prefs.remove("dateOfBirth");
    prefs.remove("gender");
    prefs.remove("crete_date");
    prefs.remove("isActive");
    prefs.remove("roleID");
    prefs.remove("image_path");
    prefs.remove("token");
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    return token!;
  }
}
