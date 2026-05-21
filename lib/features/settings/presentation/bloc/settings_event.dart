import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// ======================================================
/// BASE EVENT
/// ======================================================

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// ======================================================
/// LOAD SETTINGS
/// ======================================================

final class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

/// ======================================================
/// THEME
/// ======================================================

final class ToggleTheme extends SettingsEvent {
  final bool enabled;

  const ToggleTheme(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

final class ChangeThemeMode extends SettingsEvent {
  final ThemeMode themeMode;

  const ChangeThemeMode(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

/// ======================================================
/// NOTIFICATIONS
/// ======================================================

final class ToggleNotifications extends SettingsEvent {
  final bool enabled;

  const ToggleNotifications(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// ======================================================
/// BIOMETRICS
/// ======================================================

final class ToggleBiometrics extends SettingsEvent {
  final bool enabled;

  const ToggleBiometrics(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// ======================================================
/// DEFAULT CURRENCY
/// ======================================================

final class ChangeCurrency extends SettingsEvent {
  final String currency;

  const ChangeCurrency(this.currency);

  @override
  List<Object?> get props => [currency];
}

/// ======================================================
/// ANALYTICS
/// ======================================================

final class ToggleAnalytics extends SettingsEvent {
  final bool enabled;

  const ToggleAnalytics(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// ======================================================
/// CLEAR ERROR
/// ======================================================

final class ClearSettingsError extends SettingsEvent {
  const ClearSettingsError();
}
