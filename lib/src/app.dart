import 'dart:developer';

import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/connection_provider.dart';
import 'package:esmp_project/src/providers/edit_profile_provider.dart';
import 'package:esmp_project/src/providers/google_map_provider.dart';
import 'package:esmp_project/src/providers/items_provider.dart';
import 'package:esmp_project/src/providers/register_provider.dart';
import 'package:esmp_project/src/providers/user_provider.dart';
import 'package:esmp_project/src/providers/verify_provider.dart';
import 'package:esmp_project/src/screens/login_register/login_screen.dart';
import 'package:esmp_project/src/screens/login_register/register_info_screen.dart';
import 'package:esmp_project/src/screens/login_register/register_screen.dart';
import 'package:esmp_project/src/screens/main/main_screen.dart';
import 'package:esmp_project/src/screens/login_register/map_screen.dart';
import 'package:esmp_project/src/utils/shared_preferences.dart';
import 'package:esmp_project/src/utils/widget/showSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<UserModel?> getUserData() => UserPreferences().getUser();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VerifyProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context)=> ConnectionProvider()),
        ChangeNotifierProvider(create: (context)=> GoogleMapProvider()),
        ChangeNotifierProvider(create: (context)=> RegisterProvider()),
        ChangeNotifierProvider(create: (context)=> EditProfileProvider()),
        ChangeNotifierProvider(create: (context)=> ItemsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: getUserData(),
          builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Scaffold(body: Center(child: CircularProgressIndicator()),);
            }else if (snapshot.hasError) {
              log(snapshot.error.toString());
              showSnackBar(context, snapshot.error.toString());
              return const MainScreen();
            } else if (snapshot.data == null) {
              return const MainScreen();
            } else {
              Future.delayed(Duration.zero, () async {
                context.read<UserProvider>().setUser(snapshot.data!);
                UserPreferences().saveUser(snapshot.data!);
              });
              return const MainScreen();
            }
          },
        ),
        // home: RegisterInfoScreen(token: '123', phone: '84966191900',),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/map': (context)=> const MapScreen(),
          '/main': (context)=> const MainScreen(),
        },
      ),
    );
  }
}
