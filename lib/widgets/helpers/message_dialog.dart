import 'package:flutter/material.dart';

class MessageDialog {
  static void show(
      BuildContext context, {
        String title = 'Something went wrong',
        String message = 'Please try again!',
      }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Okay'),
            )
          ],
        );
      },
    );
  }
}
