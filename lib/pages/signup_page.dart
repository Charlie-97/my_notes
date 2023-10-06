import 'package:flutter/material.dart';
import 'package:my_notes/pages/login_page.dart';
import 'package:my_notes/router/base_navigator.dart';
import 'package:my_notes/utils/functions.dart';
import 'package:my_notes/widgets/google_button.dart';
import 'dart:developer' as devtools show log;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  static const routeName = 'signup_page';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final TextEditingController _userEmail;

  late final TextEditingController _userPassword;

  late final TextEditingController _userPasswordConfirmation;

  late final TextEditingController _userName;

  bool loadingVisibility = false;

  bool obscurePassword = true;

  bool obscurePasswordConfirmation = true;

  Icon passwordVisibilityIcon = const Icon(Icons.visibility);
  Icon confirmPasswordVisibilityIcon = const Icon(Icons.visibility);

  bool passwordsMatch = true;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _userName = TextEditingController();
    _userEmail = TextEditingController();
    _userPassword = TextEditingController();
    _userPasswordConfirmation = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _userName.dispose();
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
            'Signup',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Theme.of(context).colorScheme.onBackground,
              size: 24.0,
            ),
            onPressed: () => BaseNavigator.pop(),
          ),
          // s
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 0.5,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
          child: Center(
            child: SingleChildScrollView(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to My Notes 😁!!!',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        "Please fill in the form below and let's get started.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  TextFormField(
                    focusNode: _nameFocus,
                    onEditingComplete: () {
                      _emailFocus.requestFocus();
                    },
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.name,
                    controller: _userName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'John Doe',
                      prefixIcon: const Icon(Icons.person),
                      prefixIconColor:
                          Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  TextFormField(
                    focusNode: _emailFocus,
                    onEditingComplete: () {
                      _passwordFocus.requestFocus();
                    },
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: _userEmail,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your email address';
                      }
                      if (!validateEmail(email: value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'example@whatevermail.com',
                      prefixIcon: const Icon(Icons.mail),
                      prefixIconColor:
                          Theme.of(context).colorScheme.onBackground,
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: validatePassword,
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
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
                  Stack(children: [
                    ElevatedButton(
                      style: const ButtonStyle(),
                      onPressed: () async {
                        devtools.log('Button Pressed');
                        setState(() {
                          loadingVisibility = true;
                        });

                        final userEmail = _userEmail.text.trim();
                        final userPassword = _userPassword.text;
                        final userConfirmPassword =
                            _userPasswordConfirmation.text;

                        await _authService.signUpWithEmailAndPassword(
                            userEmail, userPassword, userConfirmPassword);
                        setState(() {
                          loadingVisibility = false;
                        });
                      },
                      child: const Text('Signup'),
                    ),
                    Visibility(
                        visible: loadingVisibility,
                        child: const CircularProgressIndicator.adaptive()),
                  ]),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          height: 15.0,
                          thickness: 2.0,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'OR',
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: Divider(
                          height: 15.0,
                          thickness: 2.0,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  GoogleButton(),
                  const SizedBox(
                    height: 24.0,
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
                          BaseNavigator.pushNamedAndclear(LoginPage.routeName);
                        },
                        child: Text(
                          "Login Here",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 100.0,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
