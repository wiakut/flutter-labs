import 'package:flutter/material.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/home_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/register_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_app_bar.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_button.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ToxicAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),

              ToxicTextField(
                label: 'Username',
                hint: 'Enter your username',
              ),
              SizedBox(height: 20),

              ToxicTextField(
                label: 'Password',
                hint: 'Enter your password',
              ),
              SizedBox(height: 40),

              ToxicButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                text: 'Login',
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account? ',
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.yellowAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}