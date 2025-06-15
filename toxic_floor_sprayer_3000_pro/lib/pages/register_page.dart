import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/cubits/auth/auth_cubit.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/cubits/auth/auth_state.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/storage/user_storage_impl.dart';
import 'package:toxic_floor_sprayer_3000_pro/data/models/user_model.dart';
import 'package:toxic_floor_sprayer_3000_pro/domain/repositories/user_repository_impl.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/home_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/login_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_app_bar.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_button.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_text_field.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _register(BuildContext context) {
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (password != confirm) {
      context.read<AuthCubit>().showFailure('Passwords do not match');
      return;
    }

    final user = UserModel(
      name: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: password.trim(),
    );

    context.read<AuthCubit>().register(user);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(UserRepositoryImpl(UserStorageImpl())),
      child: Scaffold(
        appBar: ToxicAppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => HomePage()),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Create an Account',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),

                    if (state is AuthFailure)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(state.message, style: const TextStyle(color: Colors.redAccent)),
                      ),

                    ToxicTextField(
                      label: 'Username',
                      hint: 'Enter your username',
                      controller: _usernameController,
                    ),
                    const SizedBox(height: 20),

                    ToxicTextField(
                      label: 'Email',
                      hint: 'Enter your email',
                      controller: _emailController,
                    ),
                    const SizedBox(height: 20),

                    ToxicTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 20),

                    ToxicTextField(
                      label: 'Confirm Password',
                      hint: 'Repeat your password',
                      controller: _confirmPasswordController,
                    ),
                    const SizedBox(height: 40),

                    state is AuthLoading
                        ? const CircularProgressIndicator()
                        : ToxicButton(
                            onPressed: () => _register(context),
                            text: 'Register',
                          ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? ', style: TextStyle(color: Colors.white)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => LoginPage()),
                            );
                          },
                          child: const Text('Login', style: TextStyle(color: Colors.yellowAccent)),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
