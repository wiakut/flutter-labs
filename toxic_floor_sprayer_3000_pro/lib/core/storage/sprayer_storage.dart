import '../../data/models/sprayer_model.dart';

abstract class SprayerStorage {
  Future<void> saveSprayer(String userKey, SprayerModel sprayer);
  Future<SprayerModel?> getSprayer(String userKey);
  Future<void> deleteSprayer(String userKey);
}
