import 'package:flutter/material.dart';

class ToxicTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;

  const ToxicTextField({
    Key? key,
    this.controller,
    required this.label,
    this.hint
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: Colors.greenAccent),
        fillColor: Colors.black, // Темний фон
        filled: true, // Заповнюємо фон
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
      ),
      style: TextStyle(color: Colors.white), // Світлий текст
    );
  }
}
