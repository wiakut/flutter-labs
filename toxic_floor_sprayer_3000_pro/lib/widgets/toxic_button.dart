import 'package:flutter/material.dart';

class ToxicButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Size minimumSize;
  final TextStyle? textStyle; // 👈 додаємо тут

  const ToxicButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.green,
    this.foregroundColor = Colors.black,
    this.padding = const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
    this.borderRadius = 8.0,
    this.minimumSize = const Size(0, 0),
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: padding,
        minimumSize: minimumSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}
