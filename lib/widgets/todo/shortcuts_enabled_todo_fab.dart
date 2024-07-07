import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_demo/models/Priority.dart';
import 'package:flutter_demo/models/Todo.dart';
import 'package:flutter_demo/scoped_models/app_model.dart';
import 'package:flutter_demo/widgets/helpers/common.dart';

class ShortcutsEnabledTodoFab extends StatefulWidget {
  final AppModel model;

  const ShortcutsEnabledTodoFab(this.model, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _ShortcutsEnabledTodoFabState();
  }
}

class _ShortcutsEnabledTodoFabState extends State<ShortcutsEnabledTodoFab> with TickerProviderStateMixin {
  late AppModel _model;
  late AnimationController _controller;

  @override
  void initState() {
    _model = widget.model;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 50.0,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
            ),
            child: FloatingActionButton(
              heroTag: 'low',
              backgroundColor: Colors.lightGreen,
              mini: true,
              onPressed: () {
                _model.setCurrentTodo(Todo(
                  id: Common.generateRandomNegativeInt(),
                  title: '',
                  userId: _model.user!.id,
                  priority: Priority.Low,
                  content: '',
                  done: 0
                ));

                Navigator.pushNamed(context, '/editor');
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
        SizedBox(
          height: 50.0,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
            ),
            child: FloatingActionButton(
              heroTag: 'medium',
              backgroundColor: Colors.amber,
              mini: true,
              onPressed: () {
                _model.setCurrentTodo(Todo(
                  id: Common.generateRandomNegativeInt(),
                  title: '',
                  userId: _model.user!.id,
                  priority: Priority.Medium,
                  content: '',
                  done: 0,
                ));

                Navigator.pushNamed(context, '/editor');
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
        SizedBox(
          height: 50.0,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
            ),
            child: FloatingActionButton(
              heroTag: 'high',
              backgroundColor: Colors.redAccent,
              mini: true,
              onPressed: () {
                _model.setCurrentTodo(Todo(
                  id: Common.generateRandomNegativeInt(),
                  title: '',
                  userId: _model.user!.id,
                  priority: Priority.High,
                  content: '',
                  done: 0
                ));

                Navigator.pushNamed(context, '/editor');
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
        FloatingActionButton(
          heroTag: 'main',
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return Transform(
                alignment: FractionalOffset.center,
                transform:
                    Matrix4.rotationZ(_controller.value * 0.75 * math.pi),
                child: const Icon(Icons.add),
              );
            },
          ),
          onPressed: () {
            if (_controller.isDismissed) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          },
        ),
      ],
    );
  }
}
