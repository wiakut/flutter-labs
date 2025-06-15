import 'package:flutter/material.dart';

class ToxicTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final void Function(String)? onChanged;

  const ToxicTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.greenAccent),
        fillColor: Colors.black,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.greenAccent),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
