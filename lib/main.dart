import 'dart:developer';
import 'dart:io';

import 'package:esmp_project/src/app.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) await Firebase.initializeApp();
  log('Handling a background message ${message.messageId}');
}
handleNotifications() async {
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(badge: true, alert: true, sound: true);//presentation options for Apple notifications when received in the foreground.

  FirebaseMessaging.onMessage.listen((message) async {
    log('Got a message whilst in the FOREGROUND!');
    return;
  }).onData((data) {
    log('Got a DATA message whilst in the FOREGROUND!');
    log('data from stream: ${data.data}');
  });

  // FirebaseMessaging.onMessageOpenedApp.listen((message) async {
  //   log('NOTIFICATION MESSAGE TAPPED');
  //   return;
  // }).onData((data) {
  //   log('NOTIFICATION MESSAGE TAPPED');
  //   log('data from stream: ${data.data}');
  // });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance
      .getInitialMessage()
      .then((value) => value != null ? _firebaseMessagingBackgroundHandler : false);
  return;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  // handleNotifications();
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(badge: true, alert: true, sound: true);//presentation options for Apple notifications when received in the foreground.
  //
  // // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // final fcmToken = await messaging.getToken();
  // log(fcmToken.toString());
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   log('Got a message whilst in the foreground!');
  //   log('Message data: ${message.data}');
  //
  //   if (message.notification != null) {
  //     log('Message also contained a notification: ${message.notification}');
  //   }
  // });

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: mainColor,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}
