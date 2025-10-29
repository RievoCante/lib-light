// Storage service for persisting user data and preferences
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class StorageService {
  static const String _keyUser = 'user';
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

  // User Storage (Secure - with fallback for macOS)
  Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    try {
      await _secureStorage.write(key: _keyUser, value: userJson);
    } catch (e) {
      // Fallback to SharedPreferences if secure storage fails (e.g., macOS entitlements)
      await _prefs.setString(_keyUser, userJson);
    }
  }

  Future<User?> getUser() async {
    try {
      final userJson = await _secureStorage.read(key: _keyUser);
      if (userJson == null) {
        // Try fallback to SharedPreferences
        final fallbackJson = _prefs.getString(_keyUser);
        if (fallbackJson == null) return null;

        final userMap = jsonDecode(fallbackJson) as Map<String, dynamic>;
        return User.fromJson(userMap);
      }

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(userMap);
    } catch (e) {
      // Fallback to SharedPreferences
      try {
        final fallbackJson = _prefs.getString(_keyUser);
        if (fallbackJson == null) return null;

        final userMap = jsonDecode(fallbackJson) as Map<String, dynamic>;
        return User.fromJson(userMap);
      } catch (_) {
        return null;
      }
    }
  }

  Future<void> clearUser() async {
    try {
      await _secureStorage.delete(key: _keyUser);
    } catch (e) {
      // Fallback to SharedPreferences
      await _prefs.remove(_keyUser);
    }
  }

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
