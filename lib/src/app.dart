
import 'package:esmp_project/src/providers/register_provider.dart';
import 'package:esmp_project/src/providers/verify_provider.dart';
import 'package:esmp_project/src/screens/home_screen.dart';
import 'package:esmp_project/src/screens/login_screen.dart';
import 'package:esmp_project/src/screens/register_info_screen.dart';
import 'package:esmp_project/src/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> RegisterProvider()),
        ChangeNotifierProvider(create: (context)=>VerifyProvider()),
      ],
      child: MaterialApp(
        home: LoginScreen(),
        routes: {
          '/login': (context)=> LoginScreen(),
          '/register': (context)=> RegisterScreen(),
          '/register2': (context)=> RegisterInfoScreen(),
          '/home':(context)=> HomeScreen(),
        },
      ),
    );
  }
}