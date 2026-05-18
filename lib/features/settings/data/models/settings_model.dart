import 'package:hive/hive.dart';

import '../../domain/entities/settings_entity.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 10)
class SettingsModel extends HiveObject {
  @HiveField(0)
  final bool isDarkMode;

  @HiveField(1)
  final bool notificationsEnabled;

  @HiveField(2)
  final bool biometricsEnabled;

  @HiveField(3)
  final String defaultCurrency;

  @HiveField(4)
  final bool analyticsEnabled;

  SettingsModel({
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.biometricsEnabled,
    required this.defaultCurrency,
    required this.analyticsEnabled,
  });

  factory SettingsModel.initial() {
    return SettingsModel(
      isDarkMode: true,
      notificationsEnabled: true,
      biometricsEnabled: false,
      defaultCurrency: 'USD',
      analyticsEnabled: true,
    );
  }

  SettingsEntity toEntity() {
    return SettingsEntity(
      isDarkMode: isDarkMode,
      notificationsEnabled: notificationsEnabled,
      biometricsEnabled: biometricsEnabled,
      defaultCurrency: defaultCurrency,
      analyticsEnabled: analyticsEnabled,
    );
  }

  factory SettingsModel.fromEntity(SettingsEntity entity) {
    return SettingsModel(
      isDarkMode: entity.isDarkMode,
      notificationsEnabled: entity.notificationsEnabled,
      biometricsEnabled: entity.biometricsEnabled,
      defaultCurrency: entity.defaultCurrency,
      analyticsEnabled: entity.analyticsEnabled,
    );
  }
}
