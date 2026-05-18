import '../../domain/entities/settings_entity.dart';

import '../../domain/repositories/settings_repository.dart';

import '../datasource/settings_local_datasource.dart';

import '../models/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<SettingsEntity> getSettings() async {
    final model = await localDataSource.getSettings();

    return model.toEntity();
  }

  @override
  Future<void> saveSettings(SettingsEntity settings) async {
    final model = SettingsModel.fromEntity(settings);

    await localDataSource.saveSettings(model);
  }

  @override
  Future<void> toggleTheme() async {
    final current = await getSettings();

    final updated = current.copyWith(isDarkMode: !current.isDarkMode);

    await saveSettings(updated);
  }

  @override
  Future<void> toggleNotifications() async {
    final current = await getSettings();

    final updated = current.copyWith(
      notificationsEnabled: !current.notificationsEnabled,
    );

    await saveSettings(updated);
  }

  @override
  Future<void> toggleBiometrics() async {
    final current = await getSettings();

    final updated = current.copyWith(
      biometricsEnabled: !current.biometricsEnabled,
    );

    await saveSettings(updated);
  }

  @override
  Future<void> changeCurrency(String currency) async {
    final current = await getSettings();

    final updated = current.copyWith(defaultCurrency: currency);

    await saveSettings(updated);
  }
}
