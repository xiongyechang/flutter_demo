import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_demo/scoped_models/app_model.dart';
import 'package:flutter_demo/widgets/ui_elements/loading_modal.dart';
import 'package:flutter_demo/widgets/helpers/confirm_dialog.dart';

class SettingsPage extends StatefulWidget {
  final AppModel model;

  const SettingsPage(this.model, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  PreferredSizeWidget _buildAppBar(BuildContext context, AppModel model) {
    return AppBar(
      title: const Text('Settings'),
      backgroundColor: Colors.blue,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.lock),
          onPressed: () async {
            bool? confirm = await ConfirmDialog.show(context);
            if (confirm == true) {
              Navigator.pop(context);
              model.logout();
            }
          },
        ),
      ],
    );
  }

  Widget _buildPageContent(AppModel model) {
    return model.isLoading
        ? const LoadingModal()
        : Scaffold(
            appBar: _buildAppBar(context, model),
            body: ListView(
              children: <Widget>[
                SwitchListTile(
                  activeColor: Colors.blue,
                  value: model.settings.isShortcutsEnabled,
                  onChanged: (value) {
                    model.toggleIsShortcutEnabled();
                  },
                  title: const Text('Enable shortcuts'),
                ),
                SwitchListTile(
                  activeColor: Colors.blue,
                  value: model.settings.isDarkThemeUsed,
                  onChanged: (value) {
                    model.toggleIsDarkThemeUsed();
                  },
                  title: const Text('Use dark theme'),
                )
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget? child, AppModel model) {
        return _buildPageContent(model);
      },
    );
  }
}
