import 'package:flutter/foundation.dart';
import 'package:my_notes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser authUser;
  const AuthStateLoggedIn(this.authUser);
}

class AuthStateLoggedInFailed extends AuthState {
  final Exception exception;
  const AuthStateLoggedInFailed(this.exception);
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut();
}

class AuthStateLogoutFailed extends AuthState {
  final Exception exception;
  const AuthStateLogoutFailed(this.exception);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}
