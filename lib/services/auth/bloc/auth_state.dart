import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:my_notes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  const AuthState(this.isLoading);
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized(bool isLoading) : super(isLoading);
}

class AuthStateRegistering extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateRegistering({this.exception, required bool isLoading})
      : super(isLoading);

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification(bool isLoading) : super(isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser authUser;
  const AuthStateLoggedIn(this.authUser, bool isLoading) : super(isLoading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({this.exception, required bool isLoading})
      : super(isLoading);

  @override
  List<Object?> get props => [exception, isLoading];
}

class RefreshingState extends AuthState {
  const RefreshingState(bool isLoading) : super(isLoading);
}
