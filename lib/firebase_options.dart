import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAS_xh6z8JqF3jfgXZG98cRshBjCfkmqjA',
    appId: '1:635236944155:android:77b2f90d5a281ac3bc6bbe',
    messagingSenderId: '635236944155',
    projectId: 'rumour-5f0f6',
    storageBucket: 'rumour-5f0f6.firebasestorage.app',
  );
}
