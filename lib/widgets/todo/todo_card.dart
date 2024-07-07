import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_demo/scoped_models/app_model.dart';
import 'package:flutter_demo/models/Todo.dart';
import 'package:flutter_demo/widgets/helpers/priority_helper.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;

  const TodoCard(this.todo, {super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget? child, AppModel model) {
        return Card(
          child: Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: PriorityHelper.getPriorityColor(todo.priority),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    bottomLeft: Radius.circular(4.0),
                  ),
                ),
                width: 40.0,
                height: 80.0,
                child: todo.done == 1
                    ? IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          model.toggleDone(todo.id);
                        },
                      )
                    : IconButton(
                        icon: const Icon(Icons.check_box_outline_blank),
                        onPressed: () {
                          model.toggleDone(todo.id);
                        },
                      ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    todo.title,
                    style: TextStyle(
                        fontSize: 24.0,
                        decoration: todo.done == 1
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  model.setCurrentTodo(todo);

                  Navigator.pushNamed(context, '/editor');
                },
              )
            ],
          ),
        );
      },
    );
  }
}
