import 'package:flutter/material.dart';

class ToxicAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final List<Widget>? actions;
  final bool showMqttStatus;
  final bool isMqttConnected;

  const ToxicAppBar({
    super.key,
    this.actions,
    this.showMqttStatus = false,
    this.isMqttConnected = false,
  }) : preferredSize = const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Toxic Floor Sprayer',
            style: TextStyle(
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showMqttStatus)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isMqttConnected ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      actions: actions,
    );
  }
}
