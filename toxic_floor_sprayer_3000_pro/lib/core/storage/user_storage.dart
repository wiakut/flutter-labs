import '../../data/models/user_model.dart';

abstract class UserStorage {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> deleteUser();
}
