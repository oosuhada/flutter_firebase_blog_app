// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyDzBYjJCuwhVcgIEg_n8j18K8Dn-Sz0Ib8',
    appId: '1:375984609441:web:e91ab1bf645614a86638e0',
    messagingSenderId: '375984609441',
    projectId: 'firebase-blog-app-oosu',
    authDomain: 'fir-blog-app-oosu.firebaseapp.com',
    storageBucket: 'firebase-blog-app-oosu.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDUtarxQq1GNqZ7_eQEaGBtrid2XtsbH2U',
    appId: '1:892245255636:android:7fa54b6f46f075f5f6a241',
    messagingSenderId: '892245255636',
    projectId: 'flutter-firebase-blog-ap-81b30',
    storageBucket: 'flutter-firebase-blog-ap-81b30.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyByjQL9CpEQWLo2ifiyqE-KExe0drvvt5c',
    appId: '1:892245255636:ios:3167430a78e18a43f6a241',
    messagingSenderId: '892245255636',
    projectId: 'flutter-firebase-blog-ap-81b30',
    storageBucket: 'flutter-firebase-blog-ap-81b30.firebasestorage.app',
    iosBundleId: 'com.example.flutterFirebaseBlogApp',
  );

}