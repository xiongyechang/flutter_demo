import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_demo/.env.example.dart';
import 'package:flutter_demo/models/Todo.dart';
import 'package:flutter_demo/models/Priority.dart';
import 'package:flutter_demo/scoped_models/app_model.dart';
import 'package:flutter_demo/widgets/helpers/message_dialog.dart';
import 'package:flutter_demo/widgets/helpers/confirm_dialog.dart';
import 'package:flutter_demo/widgets/ui_elements/loading_modal.dart';
import 'package:flutter_demo/widgets/form_fields/priority_form_field.dart';
import 'package:flutter_demo/widgets/form_fields/toggle_form_field.dart';

class TodoEditorPage extends StatefulWidget {
  const TodoEditorPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TodoEditorPageState();
  }
}

class _TodoEditorPageState extends State<TodoEditorPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'content': null,
    'priority': Priority.Low,
    'done': 0
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PreferredSizeWidget _buildAppBar(AppModel model) {
    return AppBar(
      title: const Text(Configure.AppName),
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

  Widget _buildFloatingActionButton(AppModel model) {
    return FloatingActionButton(
      child: const Icon(Icons.save),
      onPressed: () {
        if (!_formKey.currentState!.validate()) {
          return;
        }
        
        _formKey.currentState!.save();

        if (model.currentTodo != null && model.currentTodo?.id != null) {
          model
              .updateTodo(
            _formData['title'],
            _formData['content'],
            _formData['priority'],
            _formData['done'],
          )
              .then((bool success) {
            if (success) {
              model.setCurrentTodo(null);

              Navigator.pop(context);
            } else {
              MessageDialog.show(context);
            }
          });
        } else {
          model
              .createTodo(
            _formData['title'],
            _formData['content'],
            _formData['priority'],
            _formData['done'],
          )
              .then((bool success) {
            if (success) {
              Navigator.pop(context);
            } else {
              MessageDialog.show(context);
            }
          });
        }
      },
    );
  }

  Widget _buildTitleField(Todo? todo) {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Title'),
      initialValue: todo != null ? todo.title : '',
      validator: <String>(value) {
        if (value.isEmpty) {
          return 'Please enter todo\'s title';
        }

        return null;
      },
      onSaved: (value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildContentField(Todo? todo) {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Content'),
      initialValue: todo != null ? todo.content : '',
      maxLines: 5,
      onSaved: (value) {
        _formData['content'] = value;
      },
    );
  }

  Widget _buildOthers(Todo? todo) {
    final int done = todo?.done ?? 0;
    final Priority priority = todo?.priority ?? Priority.Low;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ToggleFormField(
          initialValue: done,
          onSaved: (int? value) {
            _formData['done'] = value;
          },
        ),
        PriorityFormField(
          initialValue: priority,
          onSaved: (Priority? value) {
            _formData['priority'] = value;
          },
        ),
      ],
    );
  }

  Widget _buildForm(AppModel model) {
    Todo? todo = model.currentTodo;
    _formData['title'] = todo?.title;
    _formData['content'] = todo?.content;
    _formData['priority'] = todo?.priority ?? Priority.Low;
    _formData['done'] = todo?.done ?? 0;

    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          _buildTitleField(todo),
          _buildContentField(todo),
          const SizedBox(
            height: 12.0,
          ),
          _buildOthers(todo),
        ],
      ),
    );
  }

  Widget _buildPageContent(AppModel model) {
    return Scaffold(
      appBar: _buildAppBar(model),
      floatingActionButton: _buildFloatingActionButton(model),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: _buildForm(model),
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
