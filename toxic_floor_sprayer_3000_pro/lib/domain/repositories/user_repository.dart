import '../../data/models/user_model.dart';

abstract class UserRepository {
  Future<void> registerUser(UserModel user);
  Future<bool> login(String email, String password);
  Future<UserModel?> getUser();
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser();
}
