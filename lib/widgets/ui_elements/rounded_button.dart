import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Icon icon;
  final VoidCallback onPressed;

  const RoundedButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.0,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.all(8.0),
        ),
        // color: Colors.blue,
        // icon: icon,
        // label: Text(label),
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(8.0)),
        // ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 20.0),
        ),
      )
          // : TextButton(
          //     style: TextButton.styleFrom(
          //       foregroundColor: Colors.white,
          //       backgroundColor: Colors.blue,
          //       padding: const EdgeInsets.all(8.0),
          //     ),
          //     // color: Colors.blue,
          //     // child: Text(label),
          //     // shape: const RoundedRectangleBorder(
          //     //   borderRadius: BorderRadius.all(Radius.circular(8.0)),
          //     // ),
          //     onPressed: onPressed,
          //     child: Text(
          //       label,
          //       style: const TextStyle(fontSize: 20.0),
          //     ),
          //   ),
    );
  }
}
