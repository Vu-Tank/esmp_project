import 'dart:async';
import 'dart:developer';

import 'package:esmp_project/src/models/user.dart';
import 'package:esmp_project/src/providers/order/canceled_provider.dart';
import 'package:esmp_project/src/providers/order/delivered_provider.dart';
import 'package:esmp_project/src/providers/order/delivering_provider.dart';
import 'package:esmp_project/src/providers/order/received_ship_provider.dart';
import 'package:esmp_project/src/providers/order/waiting_for_confirmation_provider.dart';
import 'package:esmp_project/src/providers/order/waiting_for_the_goods_provider.dart';
import 'package:esmp_project/src/providers/user/address_provider.dart';
import 'package:esmp_project/src/providers/internet/connection_provider.dart';
import 'package:esmp_project/src/providers/user/edit_profile_provider.dart';
import 'package:esmp_project/src/providers/feedback/feedback_provider.dart';
import 'package:esmp_project/src/providers/item/item_detail_provider.dart';
import 'package:esmp_project/src/providers/cart/item_provider.dart';
import 'package:esmp_project/src/providers/item/items_provider.dart';
import 'package:esmp_project/src/providers/main_screen_provider.dart';
import 'package:esmp_project/src/providers/map/map_provider.dart';
import 'package:esmp_project/src/providers/feedback/not_yet_feedback_provider.dart';
import 'package:esmp_project/src/providers/feedback/rated_provider.dart';
import 'package:esmp_project/src/providers/user/register_provider.dart';
import 'package:esmp_project/src/providers/shop/shop_provider.dart';
import 'package:esmp_project/src/providers/cart/shopping_cart_provider.dart';
import 'package:esmp_project/src/providers/user/user_provider.dart';
import 'package:esmp_project/src/providers/user/verify_provider.dart';
import 'package:esmp_project/src/screens/feedback/feedback_screen.dart';
import 'package:esmp_project/src/screens/login_register/login_screen.dart';
import 'package:esmp_project/src/screens/login_register/register_screen.dart';
import 'package:esmp_project/src/screens/main/main_screen.dart';
import 'package:esmp_project/src/screens/payment_result/waiting_callback_momo.dart';
import 'package:esmp_project/src/screens/report/report_screen.dart';
import 'package:esmp_project/src/utils/shared_preferences.dart';
import 'package:esmp_project/src/utils/widget/showSnackBar.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel channel =const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var initialzationSettingsAndroid =
    const AndroidInitializationSettings('online_shop');
    var initializationSettings =
    InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    DateTime time=DateTime.now();
    FirebaseMessaging.onMessage.listen((message){
      log('Got a message whilst in the FOREGROUND!: ${time.toString()}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: android.smallIcon,
              ),
            ));
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // Future<UserModel?> getUserData() => UserPreferences().getUser();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VerifyProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ConnectionProvider()),
        ChangeNotifierProvider(create: (context) => MainScreenProvider()),
        ChangeNotifierProvider(create: (context) => RegisterProvider()),
        ChangeNotifierProvider(create: (context) => EditProfileProvider()),
        ChangeNotifierProvider(create: (context) => ItemsProvider()),
        ChangeNotifierProvider(create: (context) => AddressProvider()),
        ChangeNotifierProvider(create: (context) => MapProvider()),
        ChangeNotifierProvider(create: (context) => ItemProvider()),
        ChangeNotifierProvider(create: (context) => ShoppingCartProvider()),
        ChangeNotifierProvider(create: (context) => StoreProvider()),
        ChangeNotifierProvider(create: (context) => FeedbackProvider()),
        ChangeNotifierProvider(create: (context) => ItemDetailProvider()),
        ChangeNotifierProvider(create: (context) => RatedProvider()),
        ChangeNotifierProvider(create: (context) => NotYetFeedbackProvider()),
        ChangeNotifierProvider(create: (context) => WaitingForTheGoodsProvider()),
        ChangeNotifierProvider(create: (context) => WaitingForConfirmationProvider()),
        ChangeNotifierProvider(create: (context) => ReceivedShipProvider()),
        ChangeNotifierProvider(create: (context) => DeliveringProvider()),
        ChangeNotifierProvider(create: (context) => DeliveredProvider()),
        ChangeNotifierProvider(create: (context) => CanceledProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: UserPreferences().getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              showSnackBar(context, snapshot.error.toString());
              return const MainScreen();
            } else if (snapshot.data == null) {
              Future.delayed(Duration.zero, () async {
                context.read<UserProvider>().logOut();
              });
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
        // home: const WaitingCallbackMomo(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/main': (context) => const MainScreen()
        },
      ),
    );
  }

  void requestPermission() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');
  }

  void getTokenFCM()async{
    await FirebaseMessaging.instance.getToken().then((value){
      log("Token FCM: ${value}");
    });
  }
}
