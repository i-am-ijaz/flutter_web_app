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
    apiKey: 'AIzaSyCaXdQlQ0QWORafKsXD0RN5WQLeGSs2yAI',
    appId: '1:217348332304:web:b2f55da3529d26377c6395',
    messagingSenderId: '217348332304',
    projectId: 'film-planner-db',
    authDomain: 'film-planner-db.firebaseapp.com',
    storageBucket: 'film-planner-db.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBMnz0KSAHcYVF7ZEKS7PZyfcPLLNqvC_8',
    appId: '1:217348332304:android:240f63d6da21e3287c6395',
    messagingSenderId: '217348332304',
    projectId: 'film-planner-db',
    storageBucket: 'film-planner-db.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAygeRJ_J1FuHgxSob-0iwLM3JGSFLtBNQ',
    appId: '1:217348332304:ios:86c498e5a8b2fecd7c6395',
    messagingSenderId: '217348332304',
    projectId: 'film-planner-db',
    storageBucket: 'film-planner-db.appspot.com',
    iosBundleId: 'com.example.webDuplicateApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAygeRJ_J1FuHgxSob-0iwLM3JGSFLtBNQ',
    appId: '1:217348332304:ios:57bf52d0bb1cd3e37c6395',
    messagingSenderId: '217348332304',
    projectId: 'film-planner-db',
    storageBucket: 'film-planner-db.appspot.com',
    iosBundleId: 'com.example.webDuplicateApp.RunnerTests',
  );
}
