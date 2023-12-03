import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:my_notes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

// class AuthStateLoading extends AuthState {
//   const AuthStateLoading();
// }

class AuthStateLoggedIn extends AuthState {
  final AuthUser authUser;
  const AuthStateLoggedIn(this.authUser);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final bool isLoading;
  final Exception? exception;
  const AuthStateLoggedOut({this.exception, required this.isLoading});

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering(this.exception);
}
