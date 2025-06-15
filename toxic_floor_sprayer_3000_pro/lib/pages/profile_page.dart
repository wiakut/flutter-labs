import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/storage/user_storage_impl.dart';
import 'package:toxic_floor_sprayer_3000_pro/domain/repositories/user_repository_impl.dart';
import 'package:toxic_floor_sprayer_3000_pro/data/models/user_model.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/login_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_app_bar.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_button.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_text_field.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/cubits/profile/profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final birthdayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProfileCubit(UserRepositoryImpl(UserStorageImpl()))..loadUser(),
      child: Scaffold(
        appBar: ToxicAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileDeleted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                );
              }
              if (state is ProfileLoaded) {
                usernameController.text = state.user.name;
                emailController.text = state.user.email;
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state is ProfileSaved)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.greenAccent),
                          ),
                        ),
                      ),
                    if (state is ProfileFailure)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.redAccent),
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
                        onPressed: () {
                          final currentState = context.read<ProfileCubit>().state;
                          if (currentState is! ProfileLoaded) return;
                          final updatedUser = UserModel(
                            name: usernameController.text.trim(),
                            email: emailController.text.trim(),
                            password: currentState.user.password,
                          );
                          context.read<ProfileCubit>().updateUser(updatedUser);
                        },
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
                          if (confirmed == true && context.mounted) {
                            context.read<ProfileCubit>().deleteUser();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}