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
    apiKey: 'COLOQUE_SEU_API_KEY_AQUI',
    appId: 'COLOQUE_SEU_APP_ID_WEB_AQUI',
    messagingSenderId: 'COLOQUE_SEU_MESSAGING_SENDER_ID_AQUI',
    projectId: 'prontuario-b0e08',
    authDomain: 'SEU_AUTH_DOMAIN.firebaseapp.com',
    storageBucket: 'SEU_STORAGE_BUCKET',
    measurementId: 'SEU_MEASUREMENT_ID',
  );

  // Android
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'COLOQUE_SEU_API_KEY_AQUI',
    appId: 'COLOQUE_SEU_APP_ID_AQUI',
    messagingSenderId: 'COLOQUE_SEU_MESSAGING_SENDER_ID_AQUI',
    projectId: 'prontuario-b0e08',
    storageBucket: 'COLOQUE_SEU_STORAGE_BUCKET_AQUI',
  );

  // iOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'COLOQUE_SEU_API_KEY_AQUI',
    appId: 'COLOQUE_SEU_APP_ID_AQUI',
    messagingSenderId: 'COLOQUE_SEU_MESSAGING_SENDER_ID_AQUI',
    projectId: 'prontuario-b0e08',
    storageBucket: 'COLOQUE_SEU_STORAGE_BUCKET_AQUI',
    iosBundleId: 'SEU_BUNDLE_ID',
  );

  // macOS
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'COLOQUE_SEU_API_KEY_AQUI',
    appId: 'COLOQUE_SEU_APP_ID_AQUI',
    messagingSenderId: 'COLOQUE_SEU_MESSAGING_SENDER_ID_AQUI',
    projectId: 'prontuario-b0e08',
    storageBucket: 'COLOQUE_SEU_STORAGE_BUCKET_AQUI',
    iosBundleId: 'SEU_BUNDLE_ID',
  );

  // Windows
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'COLOQUE_SEU_API_KEY_AQUI',
    appId: 'COLOQUE_SEU_APP_ID_AQUI',
    messagingSenderId: 'COLOQUE_SEU_MESSAGING_SENDER_ID_AQUI',
    projectId: 'prontuario-b0e08',
    storageBucket: 'COLOQUE_SEU_STORAGE_BUCKET_AQUI',
  );
}
