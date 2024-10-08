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
    apiKey: 'AIzaSyDs24q6eixGaPd4tGr4zEjt-DUk5XCFf5w',
    appId: '1:926782243641:web:6283932c53e8eb2c301ee8',
    messagingSenderId: '926782243641',
    projectId: 'whitematrix-machine-test',
    authDomain: 'whitematrix-machine-test.firebaseapp.com',
    storageBucket: 'whitematrix-machine-test.appspot.com',
    measurementId: 'G-H3JXMRR6Y3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB6nGdzmcie2FQueAuy1juVdhPwXQ5Lcdo',
    appId: '1:926782243641:android:9f3f987666f8e94c301ee8',
    messagingSenderId: '926782243641',
    projectId: 'whitematrix-machine-test',
    storageBucket: 'whitematrix-machine-test.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB3TueVhWOg4SQFgGATUtPpor-fqYBqdCA',
    appId: '1:926782243641:ios:e50b1234215d57c9301ee8',
    messagingSenderId: '926782243641',
    projectId: 'whitematrix-machine-test',
    storageBucket: 'whitematrix-machine-test.appspot.com',
    iosBundleId: 'com.whitematrix.app',
  );
}
