import 'package:flutter/material.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_app_bar.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_button.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_text_field.dart';

class ProfilePage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ToxicAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ToxicTextField(controller: usernameController, label: 'Username'),
              SizedBox(height: 20),

              ToxicTextField(controller: emailController, label: 'Email'),
              SizedBox(height: 20),

              ToxicTextField(controller: phoneController, label: 'Phone'),
              SizedBox(height: 20),

              ToxicTextField(controller: addressController, label: 'Address'),
              SizedBox(height: 20),

              ToxicTextField(controller: birthdayController, label: 'Birthday'),
              SizedBox(height: 40),

              Center(
                child: ToxicButton(
                  onPressed: () {
                  },
                  text: 'Save',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
