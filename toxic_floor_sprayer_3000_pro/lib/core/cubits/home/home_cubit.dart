import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/services/mqtt_service.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/services/network_service.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/storage/sprayer_storage_impl.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/storage/user_storage_impl.dart';
import 'package:toxic_floor_sprayer_3000_pro/data/models/sprayer_model.dart';
import 'package:toxic_floor_sprayer_3000_pro/domain/repositories/user_repository_impl.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final _userRepo = UserRepositoryImpl(UserStorageImpl());
  final _sprayerStorage = SprayerStorageImpl();
  final _networkService = NetworkService();
  final _mqttService = MqttService();

  HomeCubit() : super(HomeInitial()) {
    _mqttService.onStatusChange = (connected) {
      final current = state;
      if (current is HomeLoaded) {
        emit(current.copyWith(isMqttConnected: connected));
      }
    };
    _mqttService.connect();
    _networkService.onConnectionChange.listen((connected) {
      final current = state;
      if (current is HomeLoaded) {
        emit(current.copyWith(isOnline: connected));
      }
    });
    _load();
  }

  Future<void> _load() async {
    emit(HomeLoading());
    final user = await _userRepo.getUser();
    if (user == null) return;

    final sprayer = await _sprayerStorage.getSprayer(user.email);
    emit(HomeLoaded(
      user: user,
      sprayer: sprayer,
      isOnline: true,
      isMqttConnected: false,
      counter: 0,
    ));
  }

  void updateCounter(int delta) {
    final current = state;
    if (current is HomeLoaded) {
      final newValue = current.counter + delta;
      emit(current.copyWith(counter: newValue));
    }
  }

  Future<void> addSprayer(SprayerModel sprayer) async {
    final current = state;
    if (current is HomeLoaded) {
      await _sprayerStorage.saveSprayer(current.user.email, sprayer);
      emit(current.copyWith(sprayer: sprayer));
    }
  }

  Future<void> deleteSprayer() async {
    final current = state;
    if (current is HomeLoaded) {
      await _sprayerStorage.deleteSprayer(current.user.email);
      emit(current.copyWith(sprayer: null));
    }
  }

  void spray() {
    final current = state;
    if (current is HomeLoaded && current.sprayer != null) {
      _mqttService.publishSpray(current.sprayer!.id);
    }
  }

  @override
  Future<void> close() {
    _mqttService.disconnect();
    return super.close();
  }
}
