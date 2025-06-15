import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toxic_floor_sprayer_3000_pro/data/models/sprayer_model.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/storage/sprayer_storage_impl.dart';

part 'configuration_state.dart';

class ConfigurationCubit extends Cubit<ConfigurationState> {
  final String userKey;
  final SprayerStorageImpl _storage = SprayerStorageImpl();

  ConfigurationCubit(SprayerModel sprayer, this.userKey)
      : super(ConfigurationState(
          power: sprayer.config.power.toString(),
          interval: sprayer.config.interval.toString(),
          mode: sprayer.config.mode,
          sprayerId: sprayer.id,
          sprayerName: sprayer.name,
        ));

  void updatePower(String value) => emit(state.copyWith(power: value));
  void updateInterval(String value) => emit(state.copyWith(interval: value));
  void updateMode(String value) => emit(state.copyWith(mode: value));

  Future<void> save(void Function(SprayerModel updated) onUpdated) async {
    final updated = SprayerModel(
      id: state.sprayerId,
      name: state.sprayerName,
      config: SprayerConfig(
        power: int.tryParse(state.power) ?? 50,
        interval: int.tryParse(state.interval) ?? 10,
        mode: state.mode,
      ),
    );

    await _storage.saveSprayer(userKey, updated);
    onUpdated(updated);
  }
}
