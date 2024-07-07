import 'package:flutter/material.dart';

class ToggleFormField extends FormField<int> {
  ToggleFormField({
    super.key,
    required FormFieldSetter<int> onSaved,
    int initialValue = 0,
  }) : super(
          onSaved: onSaved,
          initialValue: initialValue,
          builder: (FormFieldState<int> state) {
            return SizedBox(
              height: 60.0,
              width: 100.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                child: state.value != null
                    ? const Icon(Icons.check)
                    : const Icon(Icons.check_box_outline_blank),
                onPressed: () {
                  state.didChange(state.value);
                },
              ),
            );
          },
        );
}
