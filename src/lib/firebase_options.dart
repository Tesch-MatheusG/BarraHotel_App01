import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) throw UnsupportedError('Web não configurado.');
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('Plataforma não configurada.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA5G5dLTDYejr5G37N1SrNVw7DJM-hXcK0',
    appId: '1:89289193114:android:23a0d445e69c019137d123',
    messagingSenderId: '89289193114',
    projectId: 'barrahotelapp01',
    storageBucket: 'barrahotelapp01.firebasestorage.app',
  );
}