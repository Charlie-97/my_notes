import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String id;
  final bool isEmailVerified;
  final String email;
  final String? displayName;

  const AuthUser({
    // required this.name,
    required this.id,
    required this.email,
    required this.isEmailVerified,
    this.displayName,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        isEmailVerified: user.emailVerified,
        email: user.email!,
        id: user.uid,
        displayName: user.displayName
      );
}
