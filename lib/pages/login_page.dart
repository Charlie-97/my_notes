import 'package:flutter/material.dart';
import 'package:my_notes/pages/signup_page.dart';
import 'package:my_notes/router/base_navigator.dart';
import 'package:my_notes/utils/functions.dart';
import 'package:my_notes/widgets/google_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const routeName = 'login_page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _userEmail;

  late final TextEditingController _userPassword;

  bool obscurePassword = true;

  Icon passwordVisibilityIcon = const Icon(Icons.visibility);

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final AuthService _authService = AuthService();

  @override
  void initState() {
    _userEmail = TextEditingController();
    _userPassword = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login Page",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // SizedBox(height: 100.0),
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
                    prefixIconColor: Theme.of(context).colorScheme.onBackground,
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
                    prefixIconColor: Theme.of(context).colorScheme.onBackground,
                    suffixIconColor: Theme.of(context).colorScheme.onBackground,
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
                ElevatedButton(
                  onPressed: () async {
                    final email = _userEmail.text;
                    final password = _userPassword.text;

                    await _authService.signInWithEmailAndPassword(
                        context, email, password);
                  },
                  child: const Text('Login'),
                ),
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
                    const Text("Don't have an account?"),
                    const SizedBox(
                      width: 5.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        BaseNavigator.pushNamed(SignupPage.routeName);
                      },
                      child: Text(
                        "Sign up Here",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 60.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
