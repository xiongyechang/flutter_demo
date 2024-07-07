import 'package:flutter/material.dart';

import 'package:flutter_demo/models/Priority.dart';
import 'package:flutter_demo/widgets/helpers/priority_helper.dart';
// import 'package:flutter_demo/widgets/helpers/priority_helper.dart';

class PriorityFormField extends FormField<Priority> {
  PriorityFormField({
    super.key,
    required FormFieldSetter<Priority> onSaved,
    Priority initialValue = Priority.Low,
  }) : super(
          onSaved: onSaved,
          initialValue: initialValue,
          builder: (FormFieldState<Priority> state) {
            return Row(
              children: Priority.values
                  .map((priority) => SizedBox(
                        height: 60.0,
                        width: 80,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: PriorityHelper.getPriorityColor(priority),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          child: state.value == priority ? const Icon(Icons.check) : Container(),
                          onPressed: () {
                            state.didChange(priority);
                          },
                        ),
                      ))
                  .toList(),
            );
          },
        );
}
