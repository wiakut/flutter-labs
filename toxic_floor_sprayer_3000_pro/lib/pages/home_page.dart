import 'package:flutter/material.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/storage/sprayer_storage_impl.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/storage/user_storage_impl.dart';
import 'package:toxic_floor_sprayer_3000_pro/data/models/sprayer_model.dart';
import 'package:toxic_floor_sprayer_3000_pro/data/models/user_model.dart';
import 'package:toxic_floor_sprayer_3000_pro/domain/repositories/user_repository_impl.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/configurations_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/login_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/profile_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_app_bar.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_button.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _userRepo = UserRepositoryImpl(UserStorageImpl());
  final _sprayerStorage = SprayerStorageImpl();

  UserModel? _user;
  SprayerModel? _sprayer;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await _userRepo.getUser();
    if (user == null) return;
    final sprayer = await _sprayerStorage.getSprayer(user.email);
    setState(() {
      _user = user;
      _sprayer = sprayer;
    });
  }

  Future<void> _showAddSprayerDialog() async {
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
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        ToxicButton(
          onPressed: () => Navigator.pop(context),
          text: 'Cancel',
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          minimumSize: const Size(100, 40),
        ),
        ToxicButton(
          onPressed: () async {
            final sprayer = SprayerModel(
              id: idController.text.trim(),
              name: nameController.text.trim(),
              config: const SprayerConfig(power: 50, interval: 10, mode: 'Auto'),
            );

            await _sprayerStorage.saveSprayer(_user!.email, sprayer);

            if (!mounted) return;

            Navigator.pop(context);
            setState(() => _sprayer = sprayer);
          },
          text: 'Add',
          backgroundColor: Colors.green,
          foregroundColor: Colors.black,
          minimumSize: const Size(100, 40),
        ),
      ],
    ),
  );
}


  Future<void> _deleteSprayer() async {
    await _sprayerStorage.deleteSprayer(_user!.email);
    setState(() => _sprayer = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ToxicAppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _sprayer == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ToxicButton(
                            onPressed: _showAddSprayerDialog,
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
                          Text(
                            '${_sprayer!.name} (ID: ${_sprayer!.id})',
                            style: const TextStyle(color: Colors.greenAccent, fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          ToxicButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('💥 Spraying acid!')),
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
                                        userKey: _user!.email,
                                        sprayer: _sprayer!,
                                        onUpdated: (updated) {
                                          setState(() => _sprayer = updated);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 20),
                              ToxicButton(
                                text: 'Delete',
                                onPressed: _deleteSprayer,
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
