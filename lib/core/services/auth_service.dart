import 'package:firebase_auth/firebase_auth.dart';
import '../errors/exceptions.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  String? get currentUid => _firebaseAuth.currentUser?.uid;

  bool get isAuthenticated => currentUser != null;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Ensures an anonymous user session exists, signing in silently if needed.
  Future<String> ensureAnonymousAuth() async {
    try {
      final existingUser = _firebaseAuth.currentUser;
      if (existingUser != null) {
        return existingUser.uid;
      }

      final credential = await _firebaseAuth.signInAnonymously();
      final user = credential.user;
      if (user == null) {
        throw const AuthException('Failed to obtain anonymous user credential.');
      }
      return user.uid;
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        e.message ?? 'Firebase anonymous sign-in error.',
        e.code,
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Unexpected authentication error: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException('Failed to sign out: $e');
    }
  }
}

