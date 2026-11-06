import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/services/auth_service.dart';
import 'core/services/firestore_service.dart';
import 'core/services/storage_service.dart';
import 'features/identity/data/repositories/identity_repository_impl.dart';
import 'features/identity/domain/repositories/identity_repository.dart';
import 'features/identity/presentation/providers/identity_provider.dart';
import 'features/room/data/repositories/room_repository_impl.dart';
import 'features/room/domain/repositories/room_repository.dart';
import 'features/room/presentation/providers/room_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configure Firestore offline persistence
  FirestoreService.configurePersistence();

  // Initialize local key-value persistence
  final storageService = await StorageService.init();

  // Initialize AuthService and authenticate anonymously
  final authService = AuthService();
  await authService.ensureAnonymousAuth().catchError((error) {
    debugPrint('Anonymous auth deferred: $error');
    return '';
  });

  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        Provider<AuthService>.value(value: authService),
        Provider<RoomRepository>(
          create: (_) => RoomRepositoryImpl(),
        ),
        ChangeNotifierProxyProvider<RoomRepository, RoomProvider>(
          create: (context) => RoomProvider(context.read<RoomRepository>()),
          update: (_, repo, prev) => prev ?? RoomProvider(repo),
        ),
        Provider<IdentityRepository>(
          create: (context) => IdentityRepositoryImpl(
            context.read<StorageService>(),
          ),
        ),
        ChangeNotifierProxyProvider<IdentityRepository, IdentityProvider>(
          create: (context) => IdentityProvider(context.read<IdentityRepository>()),
          update: (_, repo, prev) => prev ?? IdentityProvider(repo),
        ),
      ],
      child: const RumourApp(),
    ),
  );
}
