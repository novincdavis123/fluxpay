import '../entities/settings_entity.dart';

abstract class SettingsRepository {
  Future<SettingsEntity> getSettings();

  Future<void> saveSettings(SettingsEntity settings);

  Future<void> toggleTheme();

  Future<void> toggleNotifications();

  Future<void> toggleBiometrics();

  Future<void> changeCurrency(String currency);
}
