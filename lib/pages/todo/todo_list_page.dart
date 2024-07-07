import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_demo/.env.example.dart';
import 'package:flutter_demo/models/Filter.dart';
import 'package:flutter_demo/scoped_models/app_model.dart';
import 'package:flutter_demo/widgets/helpers/confirm_dialog.dart';
import 'package:flutter_demo/widgets/ui_elements/loading_modal.dart';
import 'package:flutter_demo/widgets/todo/todo_list_view.dart';
import 'package:flutter_demo/widgets/todo/shortcuts_enabled_todo_fab.dart';

class TodoListPage extends StatefulWidget {
  final AppModel model;

  const TodoListPage(this.model, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _TodoListPageState();
  }
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  void initState() {
    widget.model.fetchTodos();

    super.initState();
  }

  PreferredSizeWidget _buildAppBar(AppModel model) {
    return AppBar(
      title: const Text(Configure.AppName),
      backgroundColor: Colors.blue,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.lock),
          onPressed: () async {
            bool? confirm = await ConfirmDialog.show(context);

            if (confirm==true) {
              model.logout();
            }
          },
        ),
        PopupMenuButton<String>(
          onSelected: (String choice) {
            switch (choice) {
              case 'Settings':
                Navigator.pushNamed(context, '/settings');
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'Settings',
                child: Text('Settings'),
              )
            ];
          },
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(AppModel model) {
    if (model.settings.isShortcutsEnabled) {
      return ShortcutsEnabledTodoFab(model);
    } else {
      return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          model.setCurrentTodo(null);

          Navigator.pushNamed(context, '/editor');
        },
      );
    }
  }

  Widget _buildAllFlatButton(AppModel model) {
    return TextButton(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.all_inclusive,
            color: model.filter == Filter.All ? Colors.white : Colors.black,
          ),
          Text(
            'All',
            style: TextStyle(
              color: model.filter == Filter.All ? Colors.white : Colors.black,
            ),
          )
        ],
      ),
      onPressed: () {
        model.applyFilter(Filter.All);
      },
    );
  }

  Widget _buildDoneFlatButton(AppModel model) {
    return TextButton(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.check,
            color: model.filter == Filter.Done ? Colors.white : Colors.black,
          ),
          Text(
            'Done',
            style: TextStyle(
              color:
                  model.filter == Filter.Done ? Colors.white : Colors.black,
            ),
          )
        ],
      ),
      onPressed: () {
        model.applyFilter(Filter.Done);
      },
    );
  }

  Widget _buildNotDoneFlatButton(AppModel model) {
    return TextButton(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.check_box_outline_blank,
            color:
                model.filter == Filter.NotDone ? Colors.white : Colors.black,
          ),
          Text(
            'Not Done',
            style: TextStyle(
              color: model.filter == Filter.NotDone
                  ? Colors.white
                  : Colors.black,
            ),
          )
        ],
      ),
      onPressed: () {
        model.applyFilter(Filter.NotDone);
      },
    );
  }

  Widget _buildBottomAppBar(AppModel model) {
    return BottomAppBar(
      color: Colors.blue,
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildAllFlatButton(model),
          _buildDoneFlatButton(model),
          _buildNotDoneFlatButton(model),
          const SizedBox(
            width: 80.0,
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(AppModel model) {
    return Scaffold(
      appBar: _buildAppBar(model),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: _buildFloatingActionButton(model),
      bottomNavigationBar: _buildBottomAppBar(model),
      body: const TodoListView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget? child, AppModel model) {
        Stack stack = Stack(
          children: <Widget>[
            _buildPageContent(model),
          ],
        );

        if (model.isLoading) {
          stack.children.add(const LoadingModal());
        }

        return stack;
      },
    );
  }
}
