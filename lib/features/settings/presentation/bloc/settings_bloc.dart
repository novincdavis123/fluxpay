import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';

import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository repository;

  SettingsBloc({required this.repository}) : super(SettingsState.initial()) {
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
      final updatedSettings = state.settings.copyWith(
        isDarkMode: event.enabled,
      );

      await repository.saveSettings(updatedSettings);

      emit(
        state.copyWith(
          settings: updatedSettings,
          themeMode: event.enabled ? ThemeMode.dark : ThemeMode.light,
          clearError: true,
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
      final updatedSettings = state.settings.copyWith(
        isDarkMode: event.themeMode == ThemeMode.dark,
      );

      await repository.saveSettings(updatedSettings);

      emit(
        state.copyWith(
          settings: updatedSettings,
          themeMode: event.themeMode,
          clearError: true,
        ),
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
      final updatedSettings = state.settings.copyWith(
        notificationsEnabled: event.enabled,
      );

      await repository.saveSettings(updatedSettings);

      emit(state.copyWith(settings: updatedSettings, clearError: true));
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
      final updatedSettings = state.settings.copyWith(
        biometricsEnabled: event.enabled,
      );

      await repository.saveSettings(updatedSettings);

      emit(state.copyWith(settings: updatedSettings, clearError: true));
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
      final updatedSettings = state.settings.copyWith(
        defaultCurrency: event.currency,
      );

      await repository.saveSettings(updatedSettings);

      emit(state.copyWith(settings: updatedSettings, clearError: true));
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
      final updatedSettings = state.settings.copyWith(
        analyticsEnabled: event.enabled,
      );

      await repository.saveSettings(updatedSettings);

      emit(state.copyWith(settings: updatedSettings, clearError: true));
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
