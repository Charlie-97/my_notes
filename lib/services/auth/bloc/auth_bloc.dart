import 'package:bloc/bloc.dart';
import 'package:my_notes/services/auth/auth_provider.dart';
import 'package:my_notes/services/auth/bloc/auth_event.dart';
import 'package:my_notes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized(true)) {
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification(false));
        } else {
          emit(AuthStateLoggedIn(user, false));
        }
      },
    );
    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(const AuthStateRegistering(exception: null, isLoading: false));
      },
    );
    on<AuthEventRegister>(
      (event, emit) async {
        emit(const AuthStateRegistering(exception: null, isLoading: true));
        final email = event.email;
        final password = event.password;
        final name = event.name;
        try {
          await provider.createUser(email: email, password: password);
          await provider.sendEmailVerification();
          await provider.updateDisplayName(displayName: name as String);
          emit(const AuthStateRegistering(exception: null, isLoading: false));
          emit(const AuthStateNeedsVerification(false));
        } on Exception catch (e) {
          emit(AuthStateRegistering(exception: e, isLoading: false));
        }
      },
    );
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        emit(state);
      },
    );

    on<AuthEventLogin>(
      (event, emit) async {
        emit(const AuthStateLoggedOut(exception: null, isLoading: true));
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.login(email: email, password: password);
          if (!user.isEmailVerified) {
            emit(const AuthStateLoggedOut(exception: null, isLoading: false));
            emit(const AuthStateNeedsVerification(false));
          } else {
            emit(const AuthStateLoggedOut(exception: null, isLoading: false));
            emit(AuthStateLoggedIn(user, false));
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );
    on<AuthEventGoogleLogin>(
      (event, emit) async {
        emit(const AuthStateLoggedOut(exception: null, isLoading: true));
        try {
          final user = await provider.signInWithGoogle();
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(AuthStateLoggedIn(user, false));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );
    on<AuthEventLogout>(
      (event, emit) async {
        try {
          await provider.logout();
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );
    on<RefreshEvent>(
      (event, emit) async {
        emit(const RefreshingState(true));
        await Future.delayed(const Duration(seconds: 3));
        emit(const RefreshingState(false));
      },
    );
    on<AuthEventResetPassword>(
      (event, emit) async {
        try {
          await provider.resetPassword(event.email);
          emit(const AuthStateResettingPasssword(
              exception: null, hasSentEmail: true, isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateResettingPasssword(
              exception: e, hasSentEmail: false, isLoading: false));
        }
      },
    );
  }
}
