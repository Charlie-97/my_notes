import 'package:flutter/material.dart';
import 'package:my_notes/utils/functions.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/presentation/widgets/dialogue_boxes.dart';
import 'dart:developer' as devtools show log;

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final AppOverlays _appOverlays = AppOverlays();
  final AuthService _authService = AuthService.firebase();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50.0,
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: Text(
                    // _authService.currentUser!.email.split('@').first,
                    _authService.currentUser!.displayName!,
                  ),
                ),
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
                final auth = AuthFunctions();
                final shouldLogout =
                    await _appOverlays.showLogOutDialog(context);
                devtools.log(shouldLogout.toString());
                if (shouldLogout) {
                  auth.signOutUser(context);
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
