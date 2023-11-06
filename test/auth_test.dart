import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/auth_provider.dart';
import 'package:my_notes/services/auth/auth_user.dart';
import 'package:test/test.dart';


void main() {
  group('Mock AuthProvider', () {
    final MockAuthProvider provider = MockAuthProvider();

    // setUp(() {
    //   provider = MockAuthProvider();
    //   // TestingWidgetsBinding.ensureInitialized();
    // });

    test('should not be initialized at the start', () {
      expect(provider.isInitialized, false);
    });
    test('Cannot log out if not initialized', () {
      expect(
        provider.logout(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });
    test('SHould be able to initialize', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });
    test('Should initailize in less than 2 seconds', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));
    test('Create user should delegate to login', () async {
      final badUserEmail =
          provider.createUser(email: 'foo@bar.com', password: 'anyPassword');
      expect(
        badUserEmail,
        throwsA(
          const TypeMatcher<UserNotFoundAuthException>(),
        ),
      );
      final badUserPassword =
          provider.createUser(email: 'any@email.com', password: 'foobar');
      expect(
        badUserPassword,
        throwsA(
          const TypeMatcher<WeakPasswordAuthException>(),
        ),
      );
      final user = await provider.createUser(email: 'foo', password: 'bar');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test('Send email verification', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test('Should be able to log out and log in again', () async {
      await provider.logout();
      await provider.login(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });

    test('Should be able to signin with google', () async {
      await provider.signInWithGoogle();
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;
  AuthUser? _user;
  GoogleSignInAccount? googleUser;

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return login(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> login({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WeakPasswordAuthException();
    const user = AuthUser(
      isEmailVerified: false,
      email: 'foo@bar.com',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true, email: 'foo@bar.com');
    _user = newUser;
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    if (!isInitialized) throw NotInitializedException();
    final GoogleSignIn gSignIn = GoogleSignIn();
    final user = await gSignIn.signIn();
    if (user == null) throw GoogleSigninCancelled();
    await Future.delayed(const Duration(seconds: 1));
    const newUser = AuthUser(email: 'foo@bar.com', isEmailVerified: true);
    _user = newUser;
    return newUser;
  }
}
