import 'package:firebase_auth/firebase_auth.dart';
import 'local_auth_cache.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final LocalAuthCache _localCache = LocalAuthCache();

  /// =======================
  /// SIGN UP (ONLINE ONLY)
  /// =======================
  Future<void> signUp({
    required String email,
    required String password,
    required String role,
  }) async {
    // Create user in Firebase
    final userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Save user locally for offline login later
    await _localCache.saveUser(
      uid: userCredential.user!.uid,
      email: email,
      password: password,
      role: role,
    );
  }

  /// =======================
  /// LOGIN (ONLINE FIRST)
  /// =======================
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // If Firebase fails (offline), try local login
      final isValid = await _localCache.login(email, password);
      if (!isValid) {
        throw FirebaseAuthException(
          code: 'OFFLINE_LOGIN_FAILED',
          message: 'Offline login failed. Please connect to the internet.',
        );
      }
    }
  }
  Future<String?> getUserRole(String email) async {
  return _localCache.getUserRole(email);
}

}
