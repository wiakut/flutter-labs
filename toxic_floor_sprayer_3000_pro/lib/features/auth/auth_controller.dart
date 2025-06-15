import '../../data/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class AuthController {
  final UserRepository repository;

  AuthController(this.repository);

  Future<String?> register(UserModel user) async {
    return await repository.registerUser(user);
  }

  Future<String?> login(String email, String password) async {
    return await repository.login(email, password);
  }
}
