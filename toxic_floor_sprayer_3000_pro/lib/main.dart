import 'package:flutter/material.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/login_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
    theme: ThemeData.dark().copyWith(
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Color(0xFF121212),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.yellow),
        ),
      ),
    ),
  ));
}
