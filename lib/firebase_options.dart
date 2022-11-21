// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDAdFESdWhaMMECsiEsdkl0NZjwuR-7Vz4',
    appId: '1:688134919204:android:e4dd6cafb8e904403974b1',
    messagingSenderId: '688134919204',
    projectId: 'esmp-4b85e',
    storageBucket: 'esmp-4b85e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCgAg9OUxEbMshFjbtAa78BvwE779-56bE',
    appId: '1:688134919204:ios:2537a064d0d730913974b1',
    messagingSenderId: '688134919204',
    projectId: 'esmp-4b85e',
    storageBucket: 'esmp-4b85e.appspot.com',
    androidClientId: '688134919204-ifvcbpd4dg9n7kell7bafd90utsfefjm.apps.googleusercontent.com',
    iosClientId: '688134919204-nr93sfok59f9nkf7picgvicd9ftlq8v1.apps.googleusercontent.com',
    iosBundleId: 'com.example.esmpProject',
  );
}