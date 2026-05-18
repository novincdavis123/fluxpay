import 'package:hive/hive.dart';

import '../models/settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getSettings();

  Future<void> saveSettings(SettingsModel settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String boxName = 'settingsBox';

  static const String settingsKey = 'settings';

  @override
  Future<SettingsModel> getSettings() async {
    final box = await Hive.openBox<SettingsModel>(boxName);

    final settings = box.get(settingsKey);

    if (settings == null) {
      final initial = SettingsModel.initial();

      await box.put(settingsKey, initial);

      return initial;
    }

    return settings;
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    final box = await Hive.openBox<SettingsModel>(boxName);

    await box.put(settingsKey, settings);
  }
}
