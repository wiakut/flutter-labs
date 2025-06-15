part of 'configuration_cubit.dart';

class ConfigurationState {
  final String power;
  final String interval;
  final String mode;

  final String sprayerId;
  final String sprayerName;

  ConfigurationState({
    required this.power,
    required this.interval,
    required this.mode,
    required this.sprayerId,
    required this.sprayerName,
  });

  ConfigurationState copyWith({
    String? power,
    String? interval,
    String? mode,
  }) {
    return ConfigurationState(
      power: power ?? this.power,
      interval: interval ?? this.interval,
      mode: mode ?? this.mode,
      sprayerId: sprayerId,
      sprayerName: sprayerName,
    );
  }
}
