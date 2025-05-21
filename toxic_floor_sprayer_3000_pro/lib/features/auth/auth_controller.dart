import '../../data/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class AuthController {
  final UserRepository repository;

  AuthController(this.repository);

  Future<String?> register(UserModel user) async {
    if (!user.email.contains('@')) return 'Invalid email';
    if (user.name.contains(RegExp(r'\d'))) return 'Name can\'t contain numbers';
    if (user.password.length < 6) return 'Password too short';

    await repository.registerUser(user);
    return null;
  }

  Future<String?> login(String email, String password) async {
    final success = await repository.login(email, password);
    return success ? null : 'Invalid email or password';
  }
}
