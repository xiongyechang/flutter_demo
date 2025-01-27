import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_demo/.env.example.dart';
import 'package:flutter_demo/widgets/ui_elements/loading_modal.dart';
import 'package:flutter_demo/widgets/helpers/message_dialog.dart';
import 'package:flutter_demo/scoped_models/app_model.dart';
import 'package:flutter_demo/widgets/ui_elements/rounded_button.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _authenticate(AppModel model) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    _formKey.currentState!.save();

    Map<String, dynamic> authResult = await model.authenticate(_formData['email'], _formData['password']);

    if (authResult['success']) {
    } else {
      MessageDialog.show(context, message: authResult['message']);
    }
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Email'),
      validator: (value) {
        // if (value.isEmpty ||
        //     !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        //         .hasMatch(value)) {
        //   return 'Please enter a valid email';
        // }

        return null;
      },
      onSaved: (value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(labelText: 'Password'),
      validator: (value) {
        // if (value.isEmpty) {
        //   return 'Please enter password';
        // }

        return null;
      },
      onSaved: (value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildButtonRow(AppModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RoundedButton(
          icon: const Icon(Icons.edit),
          label: 'Register',
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
        ),
        const SizedBox(
          width: 20.0,
        ),
        RoundedButton(
          icon: const Icon(Icons.lock_open),
          label: 'Login',
          onPressed: () => _authenticate(model),
        ),
      ],
    );
  }

  Widget _buildPageContent(AppModel model) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 500 : deviceWidth * 0.85;

    return Scaffold(
      appBar: AppBar(
        title: const Text(Configure.AppName),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildEmailField(),
                    _buildPasswordField(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    _buildButtonRow(model),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget? child, AppModel model) {
        Stack mainStack = Stack(
          children: <Widget>[
            _buildPageContent(model),
          ],
        );

        if (model.isLoading) {
          mainStack.children.add(const LoadingModal());
        }

        return mainStack;
      },
    );
  }
}
