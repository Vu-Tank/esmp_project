import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            user.userID != null ? notUser() : userWidget(user),
            Center(
              child: Text("Accput"),
            )
          ],
        ),
      ),
    );
  }

  Widget notUser() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        OutlinedButton(onPressed: () {}, child: Text('Đăng nhập')),
        OutlinedButton(onPressed: () {}, child: Text('Đăng Ký')),
      ],
    );
  }

  Widget userWidget(UserModel user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ClipOval(
          child: SizedBox.fromSize(
            size: Size.fromRadius(60),
            child: Image.network(
              "https://media-cdn-v2.laodong.vn/Storage/NewsPortal/2020/6/30/816260/Cho-1.jpg",
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${user.userName}'),
            TextButton(onPressed: (){

            }, child: Text('Thông tin tài khoản')),
          ],
        ),
        IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              UserPreferences().removeUser();
              Navigator.pushNamed(context, '/login');
            },
            icon: Icon(Icons.logout))
      ],
    );
  }
}
