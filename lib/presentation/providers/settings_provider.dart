// Settings state provider for language and theme
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/storage_service.dart';
import 'auth_provider.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  final StorageService _storageService;

  SettingsNotifier(this._storageService)
    : super(
        SettingsState(
          languageCode: _storageService.getLanguage(),
          isDarkTheme: _storageService.getTheme(),
        ),
      );

  Future<void> setLanguage(String languageCode) async {
    await _storageService.saveLanguage(languageCode);
    state = state.copyWith(languageCode: languageCode);
  }

  Future<void> setTheme(bool isDark) async {
    await _storageService.saveTheme(isDark);
    state = state.copyWith(isDarkTheme: isDark);
  }

  Locale get locale => Locale(state.languageCode);
  bool get isDarkTheme => state.isDarkTheme;
  bool get isThaiLanguage => state.languageCode == 'th';
}

class SettingsState {
  final String languageCode;
  final bool isDarkTheme;

  const SettingsState({required this.languageCode, required this.isDarkTheme});

  SettingsState copyWith({String? languageCode, bool? isDarkTheme}) {
    return SettingsState(
      languageCode: languageCode ?? this.languageCode,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
    );
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    final storageService = ref.watch(storageServiceProvider);
    return SettingsNotifier(storageService);
  },
);
