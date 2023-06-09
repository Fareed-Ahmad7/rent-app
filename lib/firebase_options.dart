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
      return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBwM_h9zqJvOwSdBLJGBJx0jGX7mdFynV4',
    appId: '1:337688619824:web:859e513f0c3cdcd42ff6f5',
    messagingSenderId: '337688619824',
    projectId: 'rent-app-a98f7',
    authDomain: 'rent-app-a98f7.firebaseapp.com',
    storageBucket: 'rent-app-a98f7.appspot.com',
    measurementId: 'G-6GY7H2SXSW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLqL2bsWh57jndipE5exk9Vw23iZJn7cc',
    appId: '1:337688619824:android:dd751c7a957a5f942ff6f5',
    messagingSenderId: '337688619824',
    projectId: 'rent-app-a98f7',
    storageBucket: 'rent-app-a98f7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAeCEKVSGpWRRqtHyPjb50ZMf7zS-5uZeg',
    appId: '1:337688619824:ios:11018c41eaa74e3d2ff6f5',
    messagingSenderId: '337688619824',
    projectId: 'rent-app-a98f7',
    storageBucket: 'rent-app-a98f7.appspot.com',
    iosClientId: '337688619824-78ppqcpptdt9je3hm6ale1b1nqo32he7.apps.googleusercontent.com',
    iosBundleId: 'com.example.rentApp',
  );
}
