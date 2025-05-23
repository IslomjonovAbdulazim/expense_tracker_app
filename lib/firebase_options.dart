// lib/firebase_options.dart
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
        return macos;
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
    apiKey: 'AIzaSyDMqkAXNtfMzchTkomh6qB6v4Fuw2Ai0Wc',
    appId: '1:592777820664:web:9612b91af71298f17cbe0d',
    messagingSenderId: '592777820664',
    projectId: 'expense-tracker-7bba8',
    authDomain: 'expense-tracker-7bba8.firebaseapp.com',
    storageBucket: 'expense-tracker-7bba8.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDhA_beeI2V26GX1c2aBHUasp16zv9yNLM',
    appId: '1:592777820664:android:def3ded1120f34ed7cbe0d',
    messagingSenderId: '592777820664',
    projectId: 'expense-tracker-7bba8',
    storageBucket: 'expense-tracker-7bba8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMqkAXNtfMzchTkomh6qB6v4Fuw2Ai0Wc',
    appId: '1:592777820664:ios:9612b91af71298f17cbe0d',
    messagingSenderId: '592777820664',
    projectId: 'expense-tracker-7bba8',
    storageBucket: 'expense-tracker-7bba8.firebasestorage.app',
    iosBundleId: 'com.azimislom.expenseTrackerApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDMqkAXNtfMzchTkomh6qB6v4Fuw2Ai0Wc',
    appId: '1:592777820664:ios:9612b91af71298f17cbe0d',
    messagingSenderId: '592777820664',
    projectId: 'expense-tracker-7bba8',
    storageBucket: 'expense-tracker-7bba8.firebasestorage.app',
    iosBundleId: 'com.azimislom.expenseTrackerApp',
  );
}