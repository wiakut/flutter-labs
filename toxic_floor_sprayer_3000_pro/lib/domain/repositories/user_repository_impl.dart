import '../../core/storage/user_storage.dart';
import '../../data/models/user_model.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserStorage storage;

  UserRepositoryImpl(this.storage);

  @override
  Future<void> registerUser(UserModel user) async {
    await storage.saveUser(user);
  }

  @override
  Future<bool> login(String email, String password) async {
    final user = await storage.getUser();
    if (user == null) return false;
    return user.email == email && user.password == password;
  }

  @override
  Future<UserModel?> getUser() => storage.getUser();

  @override
  Future<void> updateUser(UserModel user) => storage.saveUser(user);

  @override
  Future<void> deleteUser() => storage.deleteUser();
}
