import 'package:flutter/material.dart';

class ToxicAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final List<Widget>? actions; // Додаємо параметр actions

  ToxicAppBar({
    Key? key,
    this.actions, // Параметр для передачі actions
  })  : preferredSize = Size.fromHeight(60.0), // Висота AppBar
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Toxic Floor Sprayer',
        style: TextStyle(
          color: Colors.greenAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.black,
      centerTitle: true,
      actions: actions, // Використовуємо передані actions
    );
  }
}
