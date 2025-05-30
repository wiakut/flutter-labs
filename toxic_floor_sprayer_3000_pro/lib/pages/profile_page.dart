import 'package:flutter/material.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/storage/user_storage_impl.dart';
import 'package:toxic_floor_sprayer_3000_pro/domain/repositories/user_repository_impl.dart';
import 'package:toxic_floor_sprayer_3000_pro/data/models/user_model.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/login_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_app_bar.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_button.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_text_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final birthdayController = TextEditingController();

  late final UserRepositoryImpl _repo;
  UserModel? _originalUser;
  String? _infoText;

  @override
  void initState() {
    super.initState();
    _repo = UserRepositoryImpl(UserStorageImpl());
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _repo.getUser();
    if (user != null) {
      setState(() {
        _originalUser = user;
        usernameController.text = user.name;
        emailController.text = user.email;
      });
    }
  }

  Future<void> _saveUser() async {
    final updatedUser = UserModel(
      name: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: _originalUser?.password ?? '',
    );

    await _repo.updateUser(updatedUser);

    if (!mounted) return;
    setState(() => _infoText = 'Changes saved!');
  }

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
              if (_infoText != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Center(
                    child: Text(
                      _infoText!,
                      style: const TextStyle(color: Colors.greenAccent),
                    ),
                  ),
                ),

              ToxicTextField(controller: usernameController, label: 'Username'),
              const SizedBox(height: 20),

              ToxicTextField(controller: emailController, label: 'Email'),
              const SizedBox(height: 20),

              ToxicTextField(controller: phoneController, label: 'Phone'),
              const SizedBox(height: 20),

              ToxicTextField(controller: addressController, label: 'Address'),
              const SizedBox(height: 20),

              ToxicTextField(controller: birthdayController, label: 'Birthday'),
              const SizedBox(height: 40),

              Center(
                child: ToxicButton(
                  onPressed: _saveUser,
                  text: 'Save',
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: ToxicButton(
                  text: 'Delete User',
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.black,
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: Colors.black,
                        title: const Text(
                          'Confirm Deletion',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        content: const Text(
                          'Are you sure you want to delete this user? This action cannot be undone.',
                          style: TextStyle(color: Colors.white),
                        ),
                        actions: [
                          ToxicButton(
                            text: 'Cancel',
                            onPressed: () => Navigator.pop(ctx, false),
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(100, 40),
                          ),
                          ToxicButton(
                            text: 'Delete',
                            onPressed: () => Navigator.pop(ctx, true),
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(100, 40),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      final repo = UserRepositoryImpl(UserStorageImpl());
                      await repo.deleteUser();
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                    }
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
