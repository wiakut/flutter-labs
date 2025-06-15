import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toxic_floor_sprayer_3000_pro/data/models/user_model.dart';
import 'package:toxic_floor_sprayer_3000_pro/domain/repositories/user_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository repository;

  ProfileCubit(this.repository) : super(ProfileInitial());

  Future<void> loadUser() async {
    final user = await repository.getUser();
    if (user != null) {
      emit(ProfileLoaded(user));
    } else {
      emit(ProfileFailure('User not found'));
    }
  }

  Future<void> updateUser(UserModel user) async {
    await repository.updateUser(user);
    emit(ProfileSaved('Changes saved!'));
    await loadUser();
  }

  Future<void> deleteUser() async {
    await repository.deleteUser();
    emit(ProfileDeleted());
  }
}
