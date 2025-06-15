import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:toxic_floor_sprayer_3000_pro/core/cubits/home/home_cubit.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/cubits/home/home_state.dart';

import 'package:toxic_floor_sprayer_3000_pro/data/models/sprayer_model.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/configurations_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/login_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/profile_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/qr_scan_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/saved_message_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_app_bar.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_button.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_text_field.dart';

import 'package:toxic_floor_sprayer_3000_pro/core/services/usb_serial_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final usbService = UsbSerialService();

  Future<void> _showAddSprayerDialog(BuildContext context, String userKey) async {
    final idController = TextEditingController();
    final nameController = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          'Add Sprayer',
          style: TextStyle(color: Colors.greenAccent),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ToxicTextField(
                controller: nameController,
                label: 'Name',
                hint: 'Enter sprayer name',
              ),
              const SizedBox(height: 16),
              ToxicTextField(
                controller: idController,
                label: 'ID',
                hint: 'Enter sprayer ID',
              ),
            ],
          ),
        ),
        actions: [
          ToxicButton(
            onPressed: () => Navigator.pop(context),
            text: 'Cancel',
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          ToxicButton(
            onPressed: () {
              final sprayer = SprayerModel(
                id: idController.text.trim(),
                name: nameController.text.trim(),
                config: const SprayerConfig(power: 50, interval: 10, mode: 'Auto'),
              );
              context.read<HomeCubit>().addSprayer(sprayer);
              Navigator.pop(context);
            },
            text: 'Add',
            backgroundColor: Colors.green,
            foregroundColor: Colors.black,
          ),
        ],
      ),
    );
  }

  void _showCounterAlert(BuildContext context, int value) {
    if (value > 100) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Увага!'),
          content: Text('Значення перевищує 100: $value'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ок'),
            )
          ],
        ),
      );
    }
  }

  void _showUsbError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('❌ Failed to connect to USB device'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading || state is HomeInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is! HomeLoaded) {
          return const Scaffold(
            body: Center(child: Text('Error loading home')),
          );
        }

        final user = state.user;
        final sprayer = state.sprayer;
        final isOnline = state.isOnline;
        final isMqttConnected = state.isMqttConnected;
        final counter = state.counter;

        return Scaffold(
          appBar: ToxicAppBar(
            showMqttStatus: true,
            isMqttConnected: isMqttConnected,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () async {
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: Colors.black,
                      title: const Text('Confirm Logout', style: TextStyle(color: Colors.greenAccent)),
                      content: const Text('Are you sure you want to log out?', style: TextStyle(color: Colors.white)),
                      actions: [
                        ToxicButton(
                          text: 'Cancel',
                          onPressed: () => Navigator.pop(ctx, false),
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                        ),
                        ToxicButton(
                          text: 'Logout',
                          onPressed: () => Navigator.pop(ctx, true),
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.black,
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout == true && context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                      (_) => false,
                    );
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.account_circle),
                tooltip: 'Profile',
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage())),
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isOnline)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    '⚠️ Offline Mode: Some features may not work',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: sprayer == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ToxicButton(
                                onPressed: () => _showAddSprayerDialog(context, user.email),
                                text: 'Add Sprayer',
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                                borderRadius: 12,
                                minimumSize: const Size(200, 100),
                                textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 40),
                              const Text(
                                'Add a new sprayer to control the toxic floor sprayer and start spraying.',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text('Значення: $counter', style: const TextStyle(fontSize: 32)),
                                  const SizedBox(width: 40),
                                  ElevatedButton(
                                    onPressed: () {
                                      context.read<HomeCubit>().updateCounter(-6);
                                      _showCounterAlert(context, counter - 6);
                                    },
                                    style: ElevatedButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(24)),
                                    child: const Icon(Icons.favorite),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      context.read<HomeCubit>().updateCounter(8);
                                      _showCounterAlert(context, counter + 8);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Ink.image(
                                      image: const AssetImage('assets/moon.jpg'),
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      child: const Center(),
                                    ),
                                  ),
                                ],
                              ),
                              Text('${sprayer.name} (ID: ${sprayer.id})', style: const TextStyle(color: Colors.greenAccent, fontSize: 20)),
                              const SizedBox(height: 20),
                              ToxicButton(
                                onPressed: () {
                                  context.read<HomeCubit>().spray();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('💥 Spraying acid! Message sent via MQTT')),
                                  );
                                },
                                text: 'Spray',
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                                borderRadius: 12,
                                minimumSize: const Size(200, 100),
                                textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ToxicButton(
                                    text: 'Configurations',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ConfigurationsPage(
                                            userKey: user.email,
                                            sprayer: sprayer,
                                            onUpdated: (updated) {
                                              context.read<HomeCubit>().addSprayer(updated);
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 20),
                                  ToxicButton(
                                    text: 'Delete',
                                    onPressed: () => context.read<HomeCubit>().deleteSprayer(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ToxicButton(
                  text: 'Scan QR',
                  onPressed: () async {
                    final connected = await usbService.connect();

                    if (!context.mounted) return;
                    
                    if (!connected) {
                      _showUsbError(context);
                      return;
                    }
                    
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const QRScannerScreen()));
                  },
                ),
                ToxicButton(
                  text: 'Saved Message',
                  onPressed: () async {
                    final connected = await usbService.connect();

                    if (!context.mounted) return;

                    if (!connected) {
                      _showUsbError(context);
                      return;
                    }

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MessageScreen()));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
