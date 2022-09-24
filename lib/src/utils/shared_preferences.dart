import 'package:esmp_project/src/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences{
  Future<bool> saveUser(UserModel user) async{
    final SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setInt("userID", user.userID!);
    prefs.setString("userName", user.userName!);
    prefs.setString("email", user.email!);
    prefs.setString("phone", user.phone!);
    prefs.setString("password", user.password!);
    prefs.setString("status", user.status!);
    prefs.setString("token", user.token!);
    prefs.setString("role", user.role!);
    prefs.setString("image", user.image!);
    // prefs.setInt("user_AddressID", user.user_AddressID!);

    return prefs.commit();
  }
  Future<UserModel> getUser() async{
    final SharedPreferences prefs=await SharedPreferences.getInstance();
    int? userID= prefs.getInt("userID");
    String? userName= prefs.getString("userName");
    String? email= prefs.getString("email");
    String? phone= prefs.getString("phone");
    String? password= prefs.getString("password");
    String? status= prefs.getString("status");
    String? token= prefs.getString("token");
    String? role= prefs.getString("role");
    String? image= prefs.getString("image");
    // int? user_AddressID=prefs.getInt("user_AddressID");

    return UserModel(
        userID: userID!,
        userName: userName!,
        email: email!,
        phone: phone!,
        password: password!,
        status: status!,
        token: token!,
        role: role!,
        image: image!,
        // user_AddressID: user_AddressID!
        );
  }
  void removeUser() async{
    final SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.remove("userID");
    prefs.remove("userName");
    prefs.remove("email");
    prefs.remove("phone");
    prefs.remove("password");
    prefs.remove("status");
    prefs.remove("token");
    prefs.remove("role");
    prefs.remove("image");
    // prefs.remove("user_AddressID");
  }
  Future<String> getToken()async{
    final SharedPreferences prefs=await SharedPreferences.getInstance();
    String? token=prefs.getString("token");
    return token!;
  }
}