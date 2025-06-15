part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  ProfileLoaded(this.user);
}

class ProfileSaved extends ProfileState {
  final String message;
  ProfileSaved(this.message);
}

class ProfileFailure extends ProfileState {
  final String message;
  ProfileFailure(this.message);
}

class ProfileDeleted extends ProfileState {}
