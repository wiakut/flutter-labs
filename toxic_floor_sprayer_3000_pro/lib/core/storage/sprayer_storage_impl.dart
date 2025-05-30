import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/sprayer_model.dart';
import 'sprayer_storage.dart';

class SprayerStorageImpl implements SprayerStorage {
  @override
  Future<void> saveSprayer(String userKey, SprayerModel sprayer) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(sprayer.toJson());
    await prefs.setString('sprayer_$userKey', jsonString);
  }

  @override
  Future<SprayerModel?> getSprayer(String userKey) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('sprayer_$userKey');
    if (jsonString == null) return null;
    return SprayerModel.fromJson(jsonDecode(jsonString));
  }

  @override
  Future<void> deleteSprayer(String userKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sprayer_$userKey');
  }
}
