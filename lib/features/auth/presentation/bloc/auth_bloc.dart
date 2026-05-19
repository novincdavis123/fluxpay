import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthState.initial()) {
    on<LoginRequested>(_onLoginRequested);

    on<LogoutRequested>(_onLogoutRequested);

    on<CheckSessionRequested>(_onCheckSessionRequested);

    on<EnableBiometricRequested>(_onEnableBiometricRequested);

    on<AuthenticateBiometricRequested>(_onAuthenticateBiometricRequested);

    on<DisableBiometricRequested>(_onDisableBiometricRequested);

    on<EnablePinRequested>(_onEnablePinRequested);

    on<SavePinRequested>(_onSavePinRequested);

    on<ValidatePinRequested>(_onValidatePinRequested);

    on<ClearSecurityRequested>(_onClearSecurityRequested);

    on<LockAppRequested>(_onLockAppRequested);

    on<UnlockAppRequested>(_onUnlockAppRequested);

    on<MarkAuthenticatedRequested>(_onMarkAuthenticatedRequested);

    on<ResetAuthErrorRequested>(_onResetAuthErrorRequested);
  }

  /// =====================================================
  /// LOGIN
  /// =====================================================

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    try {
      await Future.delayed(const Duration(seconds: 2));

      final session = AuthSession(
        accessToken: 'mock_access_token',
        refreshToken: 'mock_refresh_token',
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        biometricEnabled: false,
        pinEnabled: false,
      );

      await repository.saveSession(session);

      emit(
        state.copyWith(
          status: AuthStatus.setupSecurity,
          session: session,
          biometricEnabled: false,
          pinEnabled: false,
          biometricValidated: false,
          pinValidated: false,
          appLocked: false,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  /// =====================================================
  /// LOGOUT
  /// =====================================================

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      await repository.clearSession();

      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          clearSession: true,
          biometricEnabled: false,
          pinEnabled: false,
          biometricValidated: false,
          pinValidated: false,
          appLocked: false,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  /// =====================================================
  /// CHECK SESSION
  /// =====================================================

  Future<void> _onCheckSessionRequested(
    CheckSessionRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    try {
      final hasSession = await repository.hasValidSession();

      if (!hasSession) {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            clearSession: true,
            appLocked: false,
          ),
        );

        return;
      }

      final session = await repository.getSession();

      if (session == null) {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            clearSession: true,
            appLocked: false,
          ),
        );

        return;
      }

      /// =====================================================
      /// BIOMETRIC REQUIRED
      /// =====================================================

      if (session.biometricEnabled) {
        emit(
          state.copyWith(
            status: AuthStatus.biometricRequired,
            session: session,
            biometricEnabled: true,
            pinEnabled: session.pinEnabled,
            biometricValidated: false,
            pinValidated: false,
            appLocked: true,
            clearError: true,
          ),
        );

        return;
      }

      /// =====================================================
      /// PIN REQUIRED
      /// =====================================================

      if (session.pinEnabled) {
        emit(
          state.copyWith(
            status: AuthStatus.pinRequired,
            session: session,
            biometricEnabled: session.biometricEnabled,
            pinEnabled: true,
            biometricValidated: false,
            pinValidated: false,
            appLocked: true,
            clearError: true,
          ),
        );

        return;
      }

      /// =====================================================
      /// DIRECT AUTH
      /// =====================================================

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          session: session,
          biometricEnabled: false,
          pinEnabled: false,
          biometricValidated: true,
          pinValidated: true,
          appLocked: false,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  /// =====================================================
  /// ENABLE BIOMETRIC
  /// =====================================================

  Future<void> _onEnableBiometricRequested(
    EnableBiometricRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await repository.enableBiometric(event.biometricEnabled);

      final currentSession = state.session;

      if (currentSession == null) {
        emit(state.copyWith(biometricEnabled: event.biometricEnabled));

        return;
      }

      final updatedSession = AuthSession(
        accessToken: currentSession.accessToken,
        refreshToken: currentSession.refreshToken,
        expiresAt: currentSession.expiresAt,
        biometricEnabled: event.biometricEnabled,
        pinEnabled: currentSession.pinEnabled,
      );

      await repository.saveSession(updatedSession);

      emit(
        state.copyWith(
          session: updatedSession,
          biometricEnabled: event.biometricEnabled,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  /// =====================================================
  /// AUTHENTICATE BIOMETRIC
  /// =====================================================

  Future<void> _onAuthenticateBiometricRequested(
    AuthenticateBiometricRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    try {
      final success = await repository.authenticateWithBiometric();

      if (!success) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            biometricValidated: false,
            errorMessage: 'Biometric authentication failed',
          ),
        );

        return;
      }

      /// =====================================================
      /// PIN REQUIRED AFTER BIOMETRIC
      /// =====================================================

      if (state.pinEnabled) {
        emit(
          state.copyWith(
            status: AuthStatus.pinRequired,
            biometricValidated: true,
            appLocked: true,
            clearError: true,
          ),
        );

        return;
      }

      /// =====================================================
      /// FULL AUTH
      /// =====================================================

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          biometricValidated: true,
          pinValidated: true,
          appLocked: false,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          biometricValidated: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// =====================================================
  /// DISABLE BIOMETRIC
  /// =====================================================

  Future<void> _onDisableBiometricRequested(
    DisableBiometricRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await repository.enableBiometric(false);

      final currentSession = state.session;

      if (currentSession == null) {
        emit(
          state.copyWith(biometricEnabled: false, biometricValidated: false),
        );

        return;
      }

      final updatedSession = AuthSession(
        accessToken: currentSession.accessToken,
        refreshToken: currentSession.refreshToken,
        expiresAt: currentSession.expiresAt,
        biometricEnabled: false,
        pinEnabled: currentSession.pinEnabled,
      );

      await repository.saveSession(updatedSession);

      emit(
        state.copyWith(
          session: updatedSession,
          biometricEnabled: false,
          biometricValidated: false,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  /// =====================================================
  /// ENABLE PIN
  /// =====================================================

  Future<void> _onEnablePinRequested(
    EnablePinRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await repository.enablePin(event.enabled);

      final currentSession = state.session;

      if (currentSession == null) {
        emit(state.copyWith(pinEnabled: event.enabled));

        return;
      }

      final updatedSession = AuthSession(
        accessToken: currentSession.accessToken,
        refreshToken: currentSession.refreshToken,
        expiresAt: currentSession.expiresAt,
        biometricEnabled: currentSession.biometricEnabled,
        pinEnabled: event.enabled,
      );

      await repository.saveSession(updatedSession);

      emit(
        state.copyWith(
          session: updatedSession,
          pinEnabled: event.enabled,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  /// =====================================================
  /// SAVE PIN
  /// =====================================================

  Future<void> _onSavePinRequested(
    SavePinRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await repository.savePin(event.pin);

      await repository.enablePin(true);

      await repository.enableBiometric(event.biometricEnabled);

      final currentSession = state.session;

      if (currentSession == null) {
        return;
      }

      final updatedSession = AuthSession(
        accessToken: currentSession.accessToken,
        refreshToken: currentSession.refreshToken,
        expiresAt: currentSession.expiresAt,
        biometricEnabled: event.biometricEnabled,
        pinEnabled: true,
      );

      await repository.saveSession(updatedSession);

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          session: updatedSession,
          biometricEnabled: updatedSession.biometricEnabled,
          pinEnabled: true,
          pinValidated: true,
          biometricValidated: event.biometricEnabled,
          appLocked: false,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  /// =====================================================
  /// VALIDATE PIN
  /// =====================================================

  Future<void> _onValidatePinRequested(
    ValidatePinRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    try {
      final isValid = await repository.validatePin(event.pin);

      if (!isValid) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            pinValidated: false,
            errorMessage: 'Invalid PIN',
          ),
        );

        return;
      }

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          pinValidated: true,
          biometricValidated: state.biometricEnabled,
          appLocked: false,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  /// =====================================================
  /// CLEAR SECURITY
  /// =====================================================

  Future<void> _onClearSecurityRequested(
    ClearSecurityRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        biometricValidated: false,
        pinValidated: false,
        clearError: true,
      ),
    );
  }

  /// =====================================================
  /// LOCK APP
  /// =====================================================

  Future<void> _onLockAppRequested(
    LockAppRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.status == AuthStatus.unauthenticated) {
      return;
    }

    if (!state.hasSecurityEnabled) {
      return;
    }

    emit(
      state.copyWith(
        status: AuthStatus.locked,
        appLocked: true,
        biometricValidated: false,
        pinValidated: false,
        clearError: true,
      ),
    );
  }

  /// =====================================================
  /// UNLOCK APP
  /// =====================================================

  Future<void> _onUnlockAppRequested(
    UnlockAppRequested event,
    Emitter<AuthState> emit,
  ) async {
    final session = state.session;

    if (session == null) {
      emit(
        state.copyWith(status: AuthStatus.unauthenticated, clearSession: true),
      );

      return;
    }

    /// =====================================================
    /// BIOMETRIC REQUIRED
    /// =====================================================

    if (session.biometricEnabled) {
      emit(
        state.copyWith(
          status: AuthStatus.biometricRequired,
          appLocked: true,
          biometricValidated: false,
          pinValidated: false,
          clearError: true,
        ),
      );

      return;
    }

    /// =====================================================
    /// PIN REQUIRED
    /// =====================================================

    if (session.pinEnabled) {
      emit(
        state.copyWith(
          status: AuthStatus.pinRequired,
          appLocked: true,
          biometricValidated: false,
          pinValidated: false,
          clearError: true,
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        appLocked: false,
        biometricValidated: true,
        pinValidated: true,
        clearError: true,
      ),
    );
  }

  /// =====================================================
  /// FORCE AUTHENTICATED
  /// =====================================================

  Future<void> _onMarkAuthenticatedRequested(
    MarkAuthenticatedRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        appLocked: false,
        biometricValidated: true,
        pinValidated: true,
        clearError: true,
      ),
    );
  }

  /// =====================================================
  /// RESET AUTH ERROR
  /// =====================================================

  Future<void> _onResetAuthErrorRequested(
    ResetAuthErrorRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(clearError: true));
  }
}
