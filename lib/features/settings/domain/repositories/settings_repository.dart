import '../entities/settings_entity.dart';

abstract class SettingsRepository {
  /// ======================================================
  /// GET SETTINGS
  /// ======================================================

  Future<SettingsEntity> getSettings();

  /// ======================================================
  /// SAVE ENTIRE SETTINGS OBJECT
  /// ======================================================

  Future<void> saveSettings(SettingsEntity settings);

  /// ======================================================
  /// INDIVIDUAL UPDATE METHODS
  /// ======================================================

  Future<void> updateTheme(bool isDarkMode);

  Future<void> updateNotifications(bool enabled);

  Future<void> updateBiometrics(bool enabled);

  Future<void> updateAnalytics(bool enabled);

  Future<void> updateCurrency(String currency);

  /// ======================================================
  /// RESET SETTINGS
  /// ======================================================

  Future<void> resetSettings();
}
