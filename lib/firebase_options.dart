// Template multi-plataforma para DefaultFirebaseOptions
// Substitua os placeholders pelas credenciais reais do seu projeto
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError('Firebase options not configured for linux.');
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Web (preencha se usar web)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyDNpZfhwA7z8g_jzFe1gFKLj7Z4Pm8ZoOI",
    authDomain: "projetodswm4.firebaseapp.com",
    projectId: "projetodswm4",
    storageBucket: "projetodswm4.firebasestorage.app",
    messagingSenderId: "268304019153",
    appId: "1:268304019153:web:73565b1d70107cd6835ff0",
    measurementId: "G-V76G3V8LK8",
  );

  // Android
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyATeiMgwRPsbn5OcA0vlijplXY8FY7iDRM',
    appId: '1:268304019153:android:ff6c65062e3d3442835ff0',
    messagingSenderId: '268304019153',
    projectId: 'projetodswm4',
    storageBucket: 'projetodswm4.firebasestorage.app',
  );

  // iOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyATeiMgwRPsbn5OcA0vlijplXY8FY7iDRM',
    appId: '1:268304019153:ios:cdf7462cee2f6bf7835ff0',
    messagingSenderId: '268304019153',
    projectId: 'projetodswm4',
    storageBucket: 'projetodswm4.firebasestorage.app',
    iosBundleId: 'SEU_BUNDLE_ID',
  );

  // macOS
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyATeiMgwRPsbn5OcA0vlijplXY8FY7iDRM',
    appId: '1:268304019153:ios:cdf7462cee2f6bf7835ff0',
    messagingSenderId: '268304019153',
    projectId: 'projetodswm4',
    storageBucket: 'projetodswm4.firebasestorage.app',
    iosBundleId: 'SEU_BUNDLE_ID',
  );

  // Windows
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: "AIzaSyDNpZfhwA7z8g_jzFe1gFKLj7Z4Pm8ZoOI",
    authDomain: "projetodswm4.firebaseapp.com",
    projectId: "projetodswm4",
    storageBucket: "projetodswm4.firebasestorage.app",
    messagingSenderId: "268304019153",
    appId: "1:268304019153:web:7dbcc19d95f47f69835ff0",
    measurementId: "G-0ZJSZMR8BG",
  );
}
