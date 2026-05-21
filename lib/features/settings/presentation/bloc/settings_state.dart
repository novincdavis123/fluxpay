import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/settings_entity.dart';

class SettingsState extends Equatable {
  final SettingsEntity settings;

  final ThemeMode themeMode;

  final bool isLoading;

  final String? error;

  const SettingsState({
    required this.settings,
    required this.themeMode,
    required this.isLoading,
    this.error,
  });

  /// ======================================================
  /// INITIAL
  /// ======================================================

  factory SettingsState.initial() {
    const initialSettings = SettingsEntity(
      isDarkMode: true,
      notificationsEnabled: true,
      biometricsEnabled: false,
      defaultCurrency: 'USD',
      analyticsEnabled: true,
    );

    return SettingsState(
      settings: initialSettings,
      themeMode: initialSettings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      isLoading: false,
      error: null,
    );
  }

  /// ======================================================
  /// COPY WITH
  /// ======================================================

  SettingsState copyWith({
    SettingsEntity? settings,
    ThemeMode? themeMode,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    final updatedSettings = settings ?? this.settings;

    return SettingsState(
      settings: updatedSettings,

      /// AUTO SYNC THEME MODE
      themeMode:
          themeMode ??
          (updatedSettings.isDarkMode ? ThemeMode.dark : ThemeMode.light),

      isLoading: isLoading ?? this.isLoading,

      error: clearError ? null : (error ?? this.error),
    );
  }

  /// ======================================================
  /// HELPERS
  /// ======================================================

  bool get isDarkMode => settings.isDarkMode;

  bool get notificationsEnabled => settings.notificationsEnabled;

  bool get biometricsEnabled => settings.biometricsEnabled;

  bool get analyticsEnabled => settings.analyticsEnabled;

  String get defaultCurrency => settings.defaultCurrency;

  bool get hasError => error != null && error!.isNotEmpty;

  /// ======================================================
  /// DEBUG
  /// ======================================================

  @override
  String toString() {
    return '''
SettingsState(
  darkMode: ${settings.isDarkMode},
  notifications: ${settings.notificationsEnabled},
  biometrics: ${settings.biometricsEnabled},
  analytics: ${settings.analyticsEnabled},
  currency: ${settings.defaultCurrency},
  isLoading: $isLoading,
  error: $error
)
''';
  }

  /// ======================================================
  /// PROPS
  /// ======================================================

  @override
  List<Object?> get props => [settings, themeMode, isLoading, error];
}
