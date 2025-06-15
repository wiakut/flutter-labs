import 'package:equatable/equatable.dart';
import 'package:toxic_floor_sprayer_3000_pro/data/models/user_model.dart';
import 'package:toxic_floor_sprayer_3000_pro/data/models/sprayer_model.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final UserModel user;
  final SprayerModel? sprayer;
  final bool isOnline;
  final bool isMqttConnected;
  final int counter;

  HomeLoaded({
    required this.user,
    required this.sprayer,
    required this.isOnline,
    required this.isMqttConnected,
    required this.counter,
  });

  HomeLoaded copyWith({
    UserModel? user,
    SprayerModel? sprayer,
    bool? isOnline,
    bool? isMqttConnected,
    int? counter,
  }) {
    return HomeLoaded(
      user: user ?? this.user,
      sprayer: sprayer ?? this.sprayer,
      isOnline: isOnline ?? this.isOnline,
      isMqttConnected: isMqttConnected ?? this.isMqttConnected,
      counter: counter ?? this.counter,
    );
  }

  @override
  List<Object?> get props => [user, sprayer, isOnline, isMqttConnected, counter];
}
