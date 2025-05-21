import 'package:flutter/material.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/profile_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_app_bar.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ToxicAppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ToxicButton(
                onPressed: () {
                },
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                borderRadius: 12,
                minimumSize: Size(200, 100),
                text:'Add Sprayer',
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Add a new sprayer to control the toxic floor sprayer and start spraying.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
