import 'package:flutter/material.dart';
import 'package:flutter_demo/models/Filter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_demo/scoped_models/app_model.dart';
import 'package:flutter_demo/models/Todo.dart';
import 'package:flutter_demo/widgets/todo/todo_card.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({
    super.key
  });

  Widget _buildEmptyText(AppModel model) {
    String emptyText;
    switch (model.filter) {
      case Filter.All:
        emptyText = 'This is boring here. \r\nCreate a todo to make it crowd.';
        break;

      case Filter.Done:
        emptyText =
            'This is boring here. \r\nCreate a Done todo to make it crowd.';
        break;

      case Filter.NotDone:
        emptyText =
            'This is boring here. \r\nCreate a Not Done todo to make it crowd.';
        break;
    }

    Widget svg = SvgPicture.asset(
      'assets/todo_list.svg',
      width: 200,
    );

    return Container(
      color: const Color.fromARGB(16, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          svg,
          const SizedBox(
            height: 40.0,
          ),
          Text(
            emptyText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(AppModel model) {
    return ListView.builder(
      itemCount: model.todos.length,
      itemBuilder: (BuildContext context, int index) {
        Todo todo = model.todos[index];

        return Dismissible(
          key: Key(todo.id.toString()),
          onDismissed: (DismissDirection direction) {
            model.removeTodo(todo.id);
          },
          background: Container(color: Colors.red),
          child: TodoCard(todo),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget? child, AppModel model) {
        Widget todoCards = model.todos.isNotEmpty
            ? _buildListView(model)
            : _buildEmptyText(model);

        return todoCards;
      },
    );
  }
}
