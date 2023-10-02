import 'package:flutter/material.dart';
import 'package:my_notes/pages/login_page.dart';
import 'package:my_notes/router/base_navigator.dart';
import 'package:my_notes/utils/functions.dart';
import 'package:my_notes/widgets/snackbar_messages.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50.0,
                ),
                SizedBox(
                  width: 12.0,
                ),
                Text('Username')
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.background,
              child: const SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('data'),
                    ),
                    ListTile(
                      title: Text('data'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: TextButton.icon(
              onPressed: () {
                _authService.signOutUser(context);
                final snackbar = MySnackBar('Sign out successful').build();
                ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
                    .showSnackBar(snackbar);
                BaseNavigator.pushNamedAndReplace(LoginPage.routeName);
              },
              icon: const Icon(Icons.key),
              label: const Text('Log Out'),
            ),
          )
        ],
      ),
    );
  }
}
