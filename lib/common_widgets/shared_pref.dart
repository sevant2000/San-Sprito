import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static SharedPrefHelper? _instance;
  static SharedPreferences? _prefs;

  SharedPrefHelper._internal();

  static Future<SharedPrefHelper> getInstance() async {
    _instance ??= SharedPrefHelper._internal();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Save String
  Future<bool> saveString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }

  // Get String
  String? getString(String key) {
    return _prefs!.getString(key);
  }

  // Save Integer
  Future<bool> saveInt(String key, int value) async {
    return await _prefs!.setInt(key, value);
  }

  // Get Integer
  int? getInt(String key) {
    return _prefs!.getInt(key);
  }

  // Save Boolean
  Future<bool> saveBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }

  // Get Boolean
  bool? getBool(String key) {
    return _prefs!.getBool(key);
  }

  // Save Double
  Future<bool> saveDouble(String key, double value) async {
    return await _prefs!.setDouble(key, value);
  }

  // Get Double
  double? getDouble(String key) {
    return _prefs!.getDouble(key);
  }

  // Save String List
  Future<bool> saveStringList(String key, List<String> value) async {
    return await _prefs!.setStringList(key, value);
  }

  // Get String List
  List<String>? getStringList(String key) {
    return _prefs!.getStringList(key);
  }

  // Remove a specific key
  Future<bool> remove(String key) async {
    return await _prefs!.remove(key);
  }

  // Clear all
  Future<bool> clear() async {
    return await _prefs!.clear();
  }
}
