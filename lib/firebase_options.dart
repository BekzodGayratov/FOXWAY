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
    apiKey: 'AIzaSyAhoPfmwAK885iimNCjF5KonCYW87KKFOk',
    appId: '1:290818860474:web:d1a3cf0b09dc1d49c62983',
    messagingSenderId: '290818860474',
    projectId: 'rentoc-c3bef',
    authDomain: 'rentoc-c3bef.firebaseapp.com',
    storageBucket: 'rentoc-c3bef.appspot.com',
    measurementId: 'G-R8MY5FWHDW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfAEOUk3BFantyY-HIiyQ1qvXlAdzICFo',
    appId: '1:290818860474:android:2449dce7fb943ab3c62983',
    messagingSenderId: '290818860474',
    projectId: 'rentoc-c3bef',
    storageBucket: 'rentoc-c3bef.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCBgYqK0Ie82OURlnuoLk6uOgsJlJlT-gw',
    appId: '1:290818860474:ios:dde40cb088aa6cefc62983',
    messagingSenderId: '290818860474',
    projectId: 'rentoc-c3bef',
    storageBucket: 'rentoc-c3bef.appspot.com',
    iosBundleId: 'com.example.accountant',
  );
}
