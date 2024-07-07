import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/ui_elements/rounded_button.dart';

class ConfirmDialog {
  static Future<bool?> show(BuildContext context, [String? title]) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(title ?? 'Are you sure to logout?', textAlign: TextAlign.center),
          contentPadding: const EdgeInsets.all(12.0),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RoundedButton(
                  label: 'No',
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  icon: const Icon(Icons.error),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                RoundedButton(
                  label: 'Yes',
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  icon: const Icon(Icons.confirmation_num),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
