import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  late final SharedPreferences preferences;
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  //? ====================================================
  //? ================ Shared Preferences ================
  //? ====================================================
  //! Here The Initialization of Shared Preferences
  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  //! This Method Put Data To local Database of any Type with Key
  Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is String) {
      return preferences.setString(key, value);
    }

    if (value is int) {
      return preferences.setInt(key, value);
    }

    if (value is bool) {
      return preferences.setBool(key, value);
    }

    if (value is double) {
      return preferences.setDouble(key, value);
    }

    if (value is List<String>) {
      return preferences.setStringList(key, value);
    }

    throw UnsupportedError(
      'The type ${value.runtimeType} is not supported by SharedPreferences.',
    );
  }

  //! This Method Get Data From local Database of any Type with Key
  dynamic getData({required String key}) {
    return preferences.get(key);
  }

  //! This Method Get String Data From local Database with Key
  String? getString({required String key}) {
    return preferences.getString(key);
  }

  //! This Method Get Integer Data From local Database with Key
  int? getInt({required String key}) {
    return preferences.getInt(key);
  }

  //! This Method Get Boolean Data From local Database with Key
  bool? getBool({required String key}) {
    return preferences.getBool(key);
  }

  //! This Method Get Double Data From local Database with Key
  double? getDouble({required String key}) {
    return preferences.getDouble(key);
  }

  //! This Method Get String List Data From local Database with Key
  List<String>? getStringList({required String key}) {
    return preferences.getStringList(key);
  }

  //! This Method Check of this Key is exist
  bool containsKey({required String key}) {
    return preferences.containsKey(key);
  }

  //! This Method Remove Data From local Database with Key
  Future<bool> deleteData({required String key}) {
    return preferences.remove(key);
  }

  //! This Method Remove All Data From local Database
  Future<bool> clearAllData() {
    return preferences.clear();
  }

  //! This Method Update Data
  Future<bool> updateData({required String key, required dynamic value}) {
    return saveData(key: key, value: value);
  }

  //? ====================================================
  //? ================== Secure Storage ==================
  //? ====================================================

  //! --- save secure data ---
  Future<void> saveSecureData({
    required String key,
    required String value,
  }) async {
    await _storage.write(key: key, value: value);
  }

  //! --- get secure data ---

  Future<String?> getSecureData({required String key}) async {
    return await _storage.read(key: key);
  }

  //! --- delete secure data ---
  Future<void> deleteSecureData({required String key}) async {
    await _storage.delete(key: key);
  }

  //! --- delete all secure data ---
  Future<void> deleteAllSecureData() async {
    await _storage.deleteAll();
  }
}
