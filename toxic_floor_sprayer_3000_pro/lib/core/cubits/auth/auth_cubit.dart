import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toxic_floor_sprayer_3000_pro/data/models/user_model.dart';
import 'package:toxic_floor_sprayer_3000_pro/domain/repositories/user_repository.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository userRepository;

  AuthCubit(this.userRepository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final error = await userRepository.login(email, password);
      if (error != null) {
        emit(AuthFailure(error));
      } else {
        emit(AuthSuccess(email));
      }
    } catch (e) {
      emit(AuthFailure("Login error: $e"));
    }
  }

  Future<void> register(UserModel user) async {
    emit(AuthLoading());
    try {
      final error = await userRepository.registerUser(user);
      if (error != null) {
        emit(AuthFailure(error));
      } else {
        emit(AuthSuccess(user.email));
      }
    } catch (e) {
      emit(AuthFailure("Registration error: $e"));
    }
  }

  void reset() => emit(AuthInitial());

  void showFailure(String message) => emit(AuthFailure(message));
}
