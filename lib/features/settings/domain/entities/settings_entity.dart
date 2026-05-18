class SettingsEntity {
  final bool isDarkMode;

  final bool notificationsEnabled;

  final bool biometricsEnabled;

  final String defaultCurrency;

  final bool analyticsEnabled;

  const SettingsEntity({
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.biometricsEnabled,
    required this.defaultCurrency,
    required this.analyticsEnabled,
  });

  SettingsEntity copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    bool? biometricsEnabled,
    String? defaultCurrency,
    bool? analyticsEnabled,
  }) {
    return SettingsEntity(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
    );
  }
}
