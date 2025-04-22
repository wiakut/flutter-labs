import 'package:flutter/material.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/services/network_service.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/home_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/pages/register_page.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_app_bar.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_button.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_text_field.dart';

import 'package:toxic_floor_sprayer_3000_pro/core/storage/user_storage_impl.dart';
import 'package:toxic_floor_sprayer_3000_pro/domain/repositories/user_repository_impl.dart';
import 'package:toxic_floor_sprayer_3000_pro/features/auth/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AuthController _authController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _authController = AuthController(
      UserRepositoryImpl(UserStorageImpl()),
    );
  }

  void _showNoInternetWarning(){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No internet connection'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _navigateToHome(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  void _login() async {
    final networkService = NetworkService();
    final isOnline = await networkService.isConnected();

    if (!isOnline) {
      if (!context.mounted) return;
      
      _showNoInternetWarning();

      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final error = await _authController.login(email, password);
    if (error != null) {
      setState(() => _errorText = error);
      return;
    }

    if (!context.mounted) return;
    
    _navigateToHome();
  }

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
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              if (_errorText != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _errorText!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
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

              ToxicButton(
                onPressed: _login,
                text: 'Login',
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account? ',
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      'Sign Up',
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
