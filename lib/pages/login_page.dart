import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        backgroundColor: Theme.of(context).primaryColorLight,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: (() {
                  Navigator.pushReplacementNamed(context, '/home');
                }),
                child: const Text('Login'),
              ),
              const SizedBox(
                height: 12,
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
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: Text(
                        "Sign up Here",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
