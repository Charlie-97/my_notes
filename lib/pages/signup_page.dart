import 'package:flutter/material.dart';
import 'package:my_notes/utils/functions.dart';
import 'package:my_notes/widgets/google_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final TextEditingController _userEmail;

  late final TextEditingController _userPassword;

  late final TextEditingController _userPasswordConfirmation;

  bool obscurePassword = true;

  bool obscurePasswordConfirmation = true;

  Icon passwordVisibilityIcon = const Icon(Icons.visibility);
  Icon confirmPasswordVisibilityIcon = const Icon(Icons.visibility);

  bool passwordsMatch = true;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final AuthService _authService = AuthService();

  @override
  void initState() {
    _userEmail = TextEditingController();
    _userPassword = TextEditingController();
    _userPasswordConfirmation = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _userEmail.dispose();
    _userPassword.dispose();
    _userPasswordConfirmation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(
            'SignUp Page',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 100.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    focusNode: _emailFocus,
                    onEditingComplete: () {
                      _passwordFocus.requestFocus();
                    },
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: _userEmail,
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'example@whatevermail.com',
                      prefixIcon: const Icon(Icons.mail),
                      prefixIconColor:
                          Theme.of(context).colorScheme.onBackground,
                      errorText: validateEmail(email: _userEmail.text)
                          ? null
                          : 'Enter a valid email',
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  TextFormField(
                    focusNode: _passwordFocus,
                    onEditingComplete: () {
                      _confirmPasswordFocus.requestFocus();
                    },
                    obscureText: obscurePassword,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _userPassword,
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      errorText: checkPasswordLength(_userPassword.text)
                          ? null
                          : 'Password must be at least 8 characters',
                      labelText: 'Password',
                      hintText: 'min. 8 characters',
                      prefixIcon: const Icon(Icons.lock),
                      prefixIconColor:
                          Theme.of(context).colorScheme.onBackground,
                      suffixIconColor:
                          Theme.of(context).colorScheme.onBackground,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            final toggleVisibility = setPasswordVisibility(
                                obscureText: obscurePassword);
                            obscurePassword = !obscurePassword;
                            final newIconData = toggleVisibility();
                            passwordVisibilityIcon = Icon(newIconData);
                          });
                        },
                        icon: passwordVisibilityIcon,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  TextFormField(
                    focusNode: _confirmPasswordFocus,
                    obscureText: obscurePasswordConfirmation,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _userPasswordConfirmation,
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      errorText: checkPasswordsMatch(
                        password: _userPassword.text,
                        passwordConfirmation: _userPasswordConfirmation.text,
                      )
                          ? null
                          : '! Password Mismatch',
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock),
                      prefixIconColor:
                          Theme.of(context).colorScheme.onBackground,
                      suffixIconColor:
                          Theme.of(context).colorScheme.onBackground,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            final toggleConfirmVisibility =
                                setPasswordVisibility(
                                    obscureText: obscurePasswordConfirmation);
                            obscurePasswordConfirmation =
                                !obscurePasswordConfirmation;
                            final newIconData = toggleConfirmVisibility();
                            confirmPasswordVisibilityIcon = Icon(newIconData);
                          });
                        },
                        icon: confirmPasswordVisibilityIcon,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final userEmail = _userEmail.text;
                      final userPassword = _userPassword.text;
                      final userConfirmPassword =
                          _userPasswordConfirmation.text;

                      await _authService.signUpWithEmailAndPassword(
                          userEmail, userPassword, userConfirmPassword);
                    },
                    child: const Text('Signup'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'OR',
                    style: TextStyle(fontSize: 10.0),
                  ),
                  Divider(
                    height: 15.0,
                    thickness: 2.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  GoogleButton(),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      const SizedBox(
                        width: 5.0,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text(
                            "Login Here",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
