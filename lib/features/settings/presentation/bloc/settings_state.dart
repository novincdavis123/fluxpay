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

  factory SettingsState.initial() {
    const isDarkMode = true;

    return SettingsState(
      settings: const SettingsEntity(
        isDarkMode: isDarkMode,
        notificationsEnabled: true,
        biometricsEnabled: false,
        defaultCurrency: 'USD',
        analyticsEnabled: true,
      ),

      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      isLoading: false,

      error: null,
    );
  }

  SettingsState copyWith({
    SettingsEntity? settings,
    ThemeMode? themeMode,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,

      themeMode: themeMode ?? this.themeMode,

      isLoading: isLoading ?? this.isLoading,

      error: clearError ? null : error ?? this.error,
    );
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  @override
  List<Object?> get props => [settings, themeMode, isLoading, error];
}
