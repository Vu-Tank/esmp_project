import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/shared_preferences.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel user=Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
            },
          ),
        ],
      ),
      body:Column(
        children: [
          Center(child: Text('${user.email}'),),
          Container(
            child: ElevatedButton(
              child: Text("LogOut"),
              onPressed: (){
                FirebaseAuth.instance.signOut();
                UserPreferences().removeUser();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ),
        ],
      ),
    );
  }
}
