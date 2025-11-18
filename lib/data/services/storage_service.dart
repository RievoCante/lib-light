// Storage service for persisting app preferences
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyLanguage = 'language';
  static const String _keyTheme = 'theme';
  static const String _keyLastTab = 'lastTab';

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  StorageService({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences prefs,
  }) : _secureStorage = secureStorage,
       _prefs = prefs;

  // Initialize storage service
  static Future<StorageService> create() async {
    const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
    final prefs = await SharedPreferences.getInstance();
    return StorageService(secureStorage: secureStorage, prefs: prefs);
  }

  // Get SharedPreferences instance (for direct access if needed)
  SharedPreferences getSharedPreferences() => _prefs;

  // Language Preference
  Future<void> saveLanguage(String languageCode) async {
    await _prefs.setString(_keyLanguage, languageCode);
  }

  String getLanguage() {
    return _prefs.getString(_keyLanguage) ?? 'en';
  }

  // Theme Preference
  Future<void> saveTheme(bool isDark) async {
    await _prefs.setBool(_keyTheme, isDark);
  }

  bool getTheme() {
    return _prefs.getBool(_keyTheme) ?? false; // Default to light theme
  }

  // Last Tab
  Future<void> saveLastTab(int tabIndex) async {
    await _prefs.setInt(_keyLastTab, tabIndex);
  }

  int getLastTab() {
    return _prefs.getInt(_keyLastTab) ?? 0;
  }

  // Clear all data (for logout)
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    await _prefs.clear();
  }
}
