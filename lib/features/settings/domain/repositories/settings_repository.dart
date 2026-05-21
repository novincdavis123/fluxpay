import '../entities/settings_entity.dart';

abstract class SettingsRepository {
  /// ======================================================
  /// LOAD SETTINGS
  /// ======================================================

  Future<SettingsEntity> getSettings();

  /// ======================================================
  /// SAVE FULL SETTINGS
  /// ======================================================

  Future<void> saveSettings(SettingsEntity settings);

  /// ======================================================
  /// UPDATE INDIVIDUAL SETTINGS
  /// ======================================================

  Future<void> updateTheme(bool isDarkMode);

  Future<void> updateNotifications(bool enabled);

  Future<void> updateBiometrics(bool enabled);

  Future<void> updateAnalytics(bool enabled);

  Future<void> updateCurrency(String currency);

  /// ======================================================
  /// RESET
  /// ======================================================

  Future<void> resetSettings();

  /// ======================================================
  /// OPTIONAL HELPERS
  /// ======================================================

  Future<bool> isDarkModeEnabled();

  Future<String> getDefaultCurrency();
}
