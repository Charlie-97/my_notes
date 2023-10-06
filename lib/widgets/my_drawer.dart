import 'package:flutter/material.dart';
import 'package:my_notes/pages/login_page.dart';
import 'package:my_notes/router/base_navigator.dart';
import 'package:my_notes/utils/functions.dart';
import 'package:my_notes/widgets/dialogue_boxes.dart';
import 'package:my_notes/widgets/snackbar_messages.dart';
import 'dart:developer' as devtools show log;

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final AppOverlays _appOverlays = AppOverlays();
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
                      title: Text('Profile'),
                    ),
                    ListTile(
                      title: Text('Starred Notes'),
                    ),
                    Divider(
                      thickness: 1.0,
                    ),
                    ListTile(
                      title: Text('Settings'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: TextButton.icon(
              onPressed: () async {
                final shouldLogout =
                    await _appOverlays.showLogOutDialog(context);
                devtools.log(shouldLogout.toString());
                if (shouldLogout) {
                  await _authService
                      .signOutUser(BaseNavigator.key.currentContext!);
                  BaseNavigator.pushNamedAndclear(LoginPage.routeName);
                  final snackbar = MySnackBar('Sign out successful').build();
                  ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
                      .showSnackBar(snackbar);
                  BaseNavigator.pushNamedAndReplace(LoginPage.routeName);
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Log Out'),
            ),
          )
        ],
      ),
    );
  }
}
