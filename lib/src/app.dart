import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/user_provider.dart';
import 'package:esmp_project/src/providers/verify_provider.dart';
import 'package:esmp_project/src/screens/home_screen.dart';
import 'package:esmp_project/src/screens/login_screen.dart';
import 'package:esmp_project/src/screens/map_screen.dart';
import 'package:esmp_project/src/screens/register_info_screen.dart';
import 'package:esmp_project/src/screens/register_screen.dart';
import 'package:esmp_project/src/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<UserModel> getUserData() => UserPreferences().getUser();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VerifyProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        // home: FutureBuilder(
        //   future: getUserData(),
        //   builder: (context, snapshot) {
        //     if(snapshot.connectionState==ConnectionState.waiting){
        //       return Center(child: CircularProgressIndicator(),);
        //     }else if (snapshot.hasError) {
        //       return LoginScreen();
        //     } else if (snapshot.data?.token == null) {
        //       return LoginScreen();
        //     } else {
        //       Provider.of<UserProvider>(context).setUser(snapshot.data!);
        //       return HomeScreen();
        //     }
        //   },
        // ),
        home: RegisterInfoScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/register2': (context) => RegisterInfoScreen(),
          '/home': (context) => HomeScreen(),
          '/map': (context)=> MapScreen(),
        },
      ),
    );
  }
}
