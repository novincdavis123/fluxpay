import 'package:hive/hive.dart';

import '../models/settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getSettings();

  Future<void> saveSettings(SettingsModel settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String boxName = 'settingsBox';

  static const String settingsKey = 'settings';

  /// =====================================================
  /// GET BOX
  /// BOX IS ALREADY OPENED IN MAIN
  /// =====================================================

  Box<SettingsModel> get _box => Hive.box<SettingsModel>(boxName);

  @override
  Future<SettingsModel> getSettings() async {
    final settings = _box.get(settingsKey);

    if (settings == null) {
      final initial = SettingsModel.initial();

      await _box.put(settingsKey, initial);

      return initial;
    }

    return settings;
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    await _box.put(settingsKey, settings);
  }
}
