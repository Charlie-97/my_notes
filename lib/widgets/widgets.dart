import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

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
                Navigator.pushReplacementNamed(context, '/login');
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
