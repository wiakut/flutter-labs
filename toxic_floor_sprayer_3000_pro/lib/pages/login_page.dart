import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/cubits/auth/auth_cubit.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/cubits/auth/auth_state.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/services/network_service.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/storage/user_storage_impl.dart';
import 'package:toxic_floor_sprayer_3000_pro/domain/repositories/user_repository_impl.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/home_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/register_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_app_bar.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_button.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_text_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _showNoInternetWarning(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No internet connection'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    final networkService = NetworkService();
    final isOnline = await networkService.isConnected();

    if (!context.mounted) return;

    if (!isOnline) {
      _showNoInternetWarning(context);
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    context.read<AuthCubit>().login(email, password);
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
                      'Login',
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
                    const SizedBox(height: 40),

                    state is AuthLoading
                        ? const CircularProgressIndicator()
                        : ToxicButton(
                            onPressed: () => _login(context),
                            text: 'Login',
                          ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account? ', style: TextStyle(color: Colors.white)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => RegisterPage()),
                            );
                          },
                          child: const Text('Sign Up', style: TextStyle(color: Colors.yellowAccent)),
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
