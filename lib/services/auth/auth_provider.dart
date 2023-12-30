import 'package:my_notes/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();

  Future<AuthUser> signInWithGoogle();

  AuthUser? get currentUser;
  Future<AuthUser> login({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<void> sendEmailVerification();

  Future<void> updateDisplayName({required String displayName});
  Future<void> resetPassword(String email);
}
