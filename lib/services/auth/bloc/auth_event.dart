import 'package:flutter/foundation.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthEventLogin(this.email, this.password);
}

class AuthEventGoogleLogin extends AuthEvent {
  const AuthEventGoogleLogin();
}

class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventRegister extends AuthEvent {
  final String? name;
  final String email;
  final String password;

  const AuthEventRegister(this.name, this.email, this.password);
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class RefreshEvent extends AuthEvent {
  const RefreshEvent();
}

class AuthEventResetPassword extends AuthEvent {
  final String email;
  const AuthEventResetPassword(this.email);
}
