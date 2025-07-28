import 'package:flutter/material.dart';

class ActionBar extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onUndo;
  final VoidCallback onBack;

  const ActionBar({
    super.key,
    required this.onReset,
    required this.onUndo,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: onReset, child: Text('Reset')),
        SizedBox(width: 20, height: 40),
        ElevatedButton(onPressed: onUndo, child: Text('Undo')),
        SizedBox(width: 20, height: 40),
        ElevatedButton(onPressed: onBack, child: Text('Back')),
        SizedBox(width: 20, height: 40),
      ],
    );
  }
}
