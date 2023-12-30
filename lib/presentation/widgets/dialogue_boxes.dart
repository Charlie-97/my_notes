import 'package:flutter/material.dart';
import 'package:my_notes/utils/router/base_navigator.dart';

class AppOverlays {
  Future<bool> showLogOutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return myAlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                BaseNavigator.pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                BaseNavigator.pop(true);
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}

Future<bool> showDeleteDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: ((context) {
      return myAlertDialog(
        title: const Text('Delete Note'),
        content: const Text(
            'Deleted notes cannot be recovered. Do you wish to continue?'),
        actions: [
          TextButton(
            onPressed: () {
              BaseNavigator.pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              BaseNavigator.pop(true);
            },
            child: const Text('Delete'),
          ),
        ],
      );
    }),
  ).then((value) => value ?? false);
}

Future<bool> showCloseDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return myAlertDialog(
        title: const Text('Exit'),
        content: const Text('Do you want to exit?'),
        actions: [
          TextButton(
            onPressed: () {
              BaseNavigator.pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              BaseNavigator.pop(true);
            },
            child: const Text('Exit'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}

AlertDialog myAlertDialog({
  required Widget? title,
  required Widget? content,
  required List<Widget>? actions,
  bool? value,
}) {
  return AlertDialog(
    title: title,
    content: content,
    actions: actions,
    titlePadding: const EdgeInsets.only(
      left: 24,
      top: 20,
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 10,
    ),
    actionsPadding: const EdgeInsets.only(
      bottom: 20,
      right: 24,
    ),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(50.0),
      bottomRight: Radius.circular(50.0),
    )),
  );
}
