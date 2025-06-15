import '../../data/models/user_model.dart';

abstract class UserRepository {
  Future<String?> registerUser(UserModel user);
  Future<String?> login(String email, String password);
  Future<UserModel?> getUser();
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser();
}
