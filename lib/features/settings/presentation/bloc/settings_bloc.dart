import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';

import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository repository;

  SettingsBloc({required this.repository}) : super(SettingsState.initial()) {
    /// ======================================================
    /// EVENT HANDLERS
    /// ======================================================

    on<LoadSettings>(_onLoadSettings);

    on<ToggleTheme>(_onToggleTheme);

    on<ChangeThemeMode>(_onChangeThemeMode);

    on<ToggleNotifications>(_onToggleNotifications);

    on<ToggleBiometrics>(_onToggleBiometrics);

    on<ChangeCurrency>(_onChangeCurrency);

    on<ToggleAnalytics>(_onToggleAnalytics);

    on<ClearSettingsError>(_onClearSettingsError);
  }

  /// ======================================================
  /// LOAD SETTINGS
  /// ======================================================

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      final settings = await repository.getSettings();

      emit(
        state.copyWith(
          settings: settings,
          themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to load settings'));
    }
  }

  /// ======================================================
  /// TOGGLE THEME
  /// ======================================================

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await repository.toggleTheme();

      final updated = await repository.getSettings();

      emit(
        state.copyWith(
          settings: updated,
          themeMode: updated.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: 'Failed to change theme'));
    }
  }

  /// ======================================================
  /// CHANGE THEME MODE
  /// ======================================================

  Future<void> _onChangeThemeMode(
    ChangeThemeMode event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final updatedSettings = SettingsEntity(
        isDarkMode: event.themeMode == ThemeMode.dark,

        notificationsEnabled: state.settings.notificationsEnabled,

        biometricsEnabled: state.settings.biometricsEnabled,

        defaultCurrency: state.settings.defaultCurrency,

        analyticsEnabled: state.settings.analyticsEnabled,
      );

      emit(
        state.copyWith(settings: updatedSettings, themeMode: event.themeMode),
      );
    } catch (e) {
      emit(state.copyWith(error: 'Failed to update theme mode'));
    }
  }

  /// ======================================================
  /// TOGGLE NOTIFICATIONS
  /// ======================================================

  Future<void> _onToggleNotifications(
    ToggleNotifications event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await repository.toggleNotifications();

      final updated = await repository.getSettings();

      emit(state.copyWith(settings: updated));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to update notifications'));
    }
  }

  /// ======================================================
  /// TOGGLE BIOMETRICS
  /// ======================================================

  Future<void> _onToggleBiometrics(
    ToggleBiometrics event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await repository.toggleBiometrics();

      final updated = await repository.getSettings();

      emit(state.copyWith(settings: updated));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to update biometrics'));
    }
  }

  /// ======================================================
  /// CHANGE CURRENCY
  /// ======================================================

  Future<void> _onChangeCurrency(
    ChangeCurrency event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await repository.changeCurrency(event.currency);

      final updated = await repository.getSettings();

      emit(state.copyWith(settings: updated));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to change currency'));
    }
  }

  /// ======================================================
  /// TOGGLE ANALYTICS
  /// ======================================================

  Future<void> _onToggleAnalytics(
    ToggleAnalytics event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final updatedSettings = SettingsEntity(
        isDarkMode: state.settings.isDarkMode,

        notificationsEnabled: state.settings.notificationsEnabled,

        biometricsEnabled: state.settings.biometricsEnabled,

        defaultCurrency: state.settings.defaultCurrency,

        analyticsEnabled: !state.settings.analyticsEnabled,
      );

      emit(state.copyWith(settings: updatedSettings));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to update analytics settings'));
    }
  }

  /// ======================================================
  /// CLEAR ERROR
  /// ======================================================

  void _onClearSettingsError(
    ClearSettingsError event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(clearError: true));
  }
}
