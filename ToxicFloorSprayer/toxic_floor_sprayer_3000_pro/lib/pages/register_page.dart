import 'package:flutter/material.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/home_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/login_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_app_bar.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_button.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_text_field.dart';

class RegisterPage extends StatelessWidget {
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
                'Create an Account',
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
                label: 'Email',
                hint: 'Enter your email',
              ),
              SizedBox(height: 20),

              ToxicTextField(
                label: 'Password',
                hint: 'Enter your password',
              ),
              SizedBox(height: 20),

              ToxicTextField(
                label: 'Confirm Password',
                hint: 'Repeat your password',
              ),
              SizedBox(height: 40),

              ToxicButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                text: 'Register'
              ),
              SizedBox(height: 20),
              // Посилання на сторінку входу
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Перехід на сторінку входу
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      'Login',
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
