import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable {
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

  /// ======================================================
  /// COPY WITH
  /// ======================================================

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

  /// ======================================================
  /// SERIALIZATION
  /// ======================================================

  Map<String, dynamic> toMap() {
    return {
      'isDarkMode': isDarkMode,
      'notificationsEnabled': notificationsEnabled,
      'biometricsEnabled': biometricsEnabled,
      'defaultCurrency': defaultCurrency,
      'analyticsEnabled': analyticsEnabled,
    };
  }

  factory SettingsEntity.fromMap(Map<String, dynamic> map) {
    return SettingsEntity(
      isDarkMode: map['isDarkMode'] ?? true,

      notificationsEnabled: map['notificationsEnabled'] ?? true,

      biometricsEnabled: map['biometricsEnabled'] ?? false,

      defaultCurrency: map['defaultCurrency'] ?? 'USD',

      analyticsEnabled: map['analyticsEnabled'] ?? true,
    );
  }

  /// ======================================================
  /// PROPS
  /// ======================================================

  @override
  List<Object?> get props => [
    isDarkMode,
    notificationsEnabled,
    biometricsEnabled,
    defaultCurrency,
    analyticsEnabled,
  ];
}
