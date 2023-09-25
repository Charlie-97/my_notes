import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_notes/utils/functions.dart';
import 'package:my_notes/firebase_options.dart';

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

  Icon passwordVisibilityIcon = Icon(Icons.visibility);
  Icon confirmPasswordVisibilityIcon = Icon(Icons.visibility);

  bool passwordsMatch = true;

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
      appBar: AppBar(
        title: const Text('SignUp Page'),
        backgroundColor: Theme.of(context).primaryColorLight,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        controller: _userEmail,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'example@whatevermail.com',
                          prefixIcon: Icon(Icons.mail),
                        ),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      TextFormField(
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
                            passwordConfirmation:
                                _userPasswordConfirmation.text,
                          )
                              ? null
                              : '! Password Mismatch',
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                final toggleConfirmVisibility =
                                    setPasswordVisibility(
                                        obscureText:
                                            obscurePasswordConfirmation);
                                obscurePasswordConfirmation =
                                    !obscurePasswordConfirmation;
                                final newIconData = toggleConfirmVisibility();
                                confirmPasswordVisibilityIcon =
                                    Icon(newIconData);
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

                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: userEmail,
                            password: userPassword,
                          );
                          print(userCredential);
                          // Navigator.pushReplacementNamed(context, '/home');
                        },
                        child: const Text('Signup'),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Divider(
                        height: 15.0,
                        thickness: 2.0,
                        color: Theme.of(context).colorScheme.inversePrimary,
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
                                Navigator.pushReplacementNamed(
                                    context, '/login');
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
              );

            case ConnectionState.waiting:
              return const Text('data');


            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}
