import 'package:flutter/foundation.dart';

import 'package:hive/hive.dart';

import 'package:fluxpay/core/constants/hive_boxes.dart';

import '../models/settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getSettings();

  Future<void> saveSettings(SettingsModel settings);

  Future<void> clearSettings();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String boxName = HiveBoxes.settings;

  static const String settingsKey = 'settings';

  /// =====================================================
  /// GET BOX
  /// =====================================================

  Box<SettingsModel> get _box => Hive.box<SettingsModel>(boxName);

  /// =====================================================
  /// GET SETTINGS
  /// =====================================================

  @override
  Future<SettingsModel> getSettings() async {
    try {
      final settings = _box.get(settingsKey);

      if (settings == null) {
        final initial = SettingsModel.initial();

        await _box.put(settingsKey, initial);

        return initial;
      }

      return settings;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to load settings: $e');
      }

      final fallback = SettingsModel.initial();

      await _box.put(settingsKey, fallback);

      return fallback;
    }
  }

  /// =====================================================
  /// SAVE SETTINGS
  /// =====================================================

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    try {
      await _box.put(settingsKey, settings);

      await _box.flush();

      if (kDebugMode) {
        debugPrint('✅ Settings saved successfully');
        debugPrint('Dark Mode => ${settings.isDarkMode}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to save settings: $e');
      }

      rethrow;
    }
  }

  /// =====================================================
  /// CLEAR SETTINGS
  /// =====================================================

  @override
  Future<void> clearSettings() async {
    await _box.delete(settingsKey);

    await _box.flush();
  }
}
