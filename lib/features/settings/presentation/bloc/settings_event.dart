import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// ======================================================
/// LOAD SETTINGS
/// ======================================================

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

/// ======================================================
/// TOGGLE THEME
/// ======================================================

class ToggleTheme extends SettingsEvent {
  const ToggleTheme();
}

/// ======================================================
/// CHANGE THEME MODE
/// ======================================================

class ChangeThemeMode extends SettingsEvent {
  final ThemeMode themeMode;

  const ChangeThemeMode(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

/// ======================================================
/// TOGGLE NOTIFICATIONS
/// ======================================================

class ToggleNotifications extends SettingsEvent {
  const ToggleNotifications();
}

/// ======================================================
/// TOGGLE BIOMETRICS
/// ======================================================

class ToggleBiometrics extends SettingsEvent {
  const ToggleBiometrics();
}

/// ======================================================
/// CHANGE DEFAULT CURRENCY
/// ======================================================

class ChangeCurrency extends SettingsEvent {
  final String currency;

  const ChangeCurrency(this.currency);

  @override
  List<Object?> get props => [currency];
}

/// ======================================================
/// TOGGLE ANALYTICS
/// ======================================================

class ToggleAnalytics extends SettingsEvent {
  const ToggleAnalytics();
}

/// ======================================================
/// CLEAR SETTINGS ERROR
/// ======================================================

class ClearSettingsError extends SettingsEvent {
  const ClearSettingsError();
}
