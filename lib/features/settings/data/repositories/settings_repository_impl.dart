import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';

import '../datasource/settings_local_datasource.dart';
import '../models/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  /// ======================================================
  /// GET SETTINGS
  /// ======================================================

  @override
  Future<SettingsEntity> getSettings() async {
    final model = await localDataSource.getSettings();

    return model.toEntity();
  }

  /// ======================================================
  /// SAVE SETTINGS
  /// ======================================================

  @override
  Future<void> saveSettings(SettingsEntity settings) async {
    final model = SettingsModel.fromEntity(settings);

    await localDataSource.saveSettings(model);
  }

  /// ======================================================
  /// UPDATE THEME
  /// ======================================================

  @override
  Future<void> updateTheme(bool isDarkMode) async {
    final current = await getSettings();

    final updated = current.copyWith(isDarkMode: isDarkMode);

    await saveSettings(updated);
  }

  /// ======================================================
  /// UPDATE NOTIFICATIONS
  /// ======================================================

  @override
  Future<void> updateNotifications(bool enabled) async {
    final current = await getSettings();

    final updated = current.copyWith(notificationsEnabled: enabled);

    await saveSettings(updated);
  }

  /// ======================================================
  /// UPDATE BIOMETRICS
  /// ======================================================

  @override
  Future<void> updateBiometrics(bool enabled) async {
    final current = await getSettings();

    final updated = current.copyWith(biometricsEnabled: enabled);

    await saveSettings(updated);
  }

  /// ======================================================
  /// UPDATE ANALYTICS
  /// ======================================================

  @override
  Future<void> updateAnalytics(bool enabled) async {
    final current = await getSettings();

    final updated = current.copyWith(analyticsEnabled: enabled);

    await saveSettings(updated);
  }

  /// ======================================================
  /// UPDATE CURRENCY
  /// ======================================================

  @override
  Future<void> updateCurrency(String currency) async {
    final current = await getSettings();

    final updated = current.copyWith(defaultCurrency: currency);

    await saveSettings(updated);
  }

  /// ======================================================
  /// HELPERS
  /// ======================================================

  @override
  Future<bool> isDarkModeEnabled() async {
    final settings = await getSettings();

    return settings.isDarkMode;
  }

  @override
  Future<String> getDefaultCurrency() async {
    final settings = await getSettings();

    return settings.defaultCurrency;
  }

  /// ======================================================
  /// RESET SETTINGS
  /// ======================================================

  @override
  Future<void> resetSettings() async {
    const defaultSettings = SettingsEntity(
      isDarkMode: false,
      notificationsEnabled: true,
      biometricsEnabled: false,
      defaultCurrency: 'USD',
      analyticsEnabled: true,
    );

    await saveSettings(defaultSettings);
  }
}
