class SprayerModel {
  final String id;
  final String name;
  final SprayerConfig config;

  const SprayerModel({
    required this.id,
    required this.name,
    required this.config,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'config': config.toJson(),
      };

  factory SprayerModel.fromJson(Map<String, dynamic> json) => SprayerModel(
        id: json['id'],
        name: json['name'],
        config: SprayerConfig.fromJson(json['config']),
      );
}

class SprayerConfig {
  final int power;
  final int interval;
  final String mode;

  const SprayerConfig({
    required this.power,
    required this.interval,
    required this.mode,
  });

  Map<String, dynamic> toJson() => {
        'power': power,
        'interval': interval,
        'mode': mode,
      };

  factory SprayerConfig.fromJson(Map<String, dynamic> json) => SprayerConfig(
        power: json['power'],
        interval: json['interval'],
        mode: json['mode'],
      );
}
