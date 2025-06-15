import '../../core/storage/user_storage.dart';
import '../../data/models/user_model.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserStorage storage;

  UserRepositoryImpl(this.storage);

  @override
  Future<String?> registerUser(UserModel user) async {
    if (user.email.isEmpty || user.password.isEmpty) {
      return 'Email and password are required';
    }

    final existingUser = await storage.getUser();
    if (existingUser != null) {
      return 'User already registered';
    }

    await storage.saveUser(user);
    return null; // успіх
  }

  @override
  Future<String?> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return 'Email and password are required';
    }

    final user = await storage.getUser();
    if (user == null) {
      return 'User not found';
    }

    if (user.email != email || user.password != password) {
      return 'Invalid credentials';
    }

    return null; // успіх
  }

  @override
  Future<UserModel?> getUser() => storage.getUser();

  @override
  Future<void> updateUser(UserModel user) => storage.saveUser(user);

  @override
  Future<void> deleteUser() => storage.deleteUser();
}
