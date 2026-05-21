import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:fluxpay/core/constants/hive_boxes.dart';

import 'package:fluxpay/features/transactions/data/models/transaction_model.dart';
import 'package:fluxpay/features/exchange/data/models/exchange_rate_model.dart';
import 'package:fluxpay/features/beneficiaries/data/models/beneficiary_hive_model.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthState.initial()) {
    on<LoginRequested>(_onLoginRequested);

    on<LogoutRequested>(_onLogoutRequested);

    on<SessionExpiredLogoutRequested>(_onSessionExpiredLogoutRequested);

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
    if (kDebugMode) {
      debugPrint('================ LOGIN START ================');
    }

    try {
      final biometricEnabled = await repository.isBiometricEnabled();

      final pinEnabled = await repository.isPinEnabled();

      final hasSecurity = await repository.hasSecuritySetup();

      final session = AuthSession(
        accessToken: 'mock_access_token',
        refreshToken: 'mock_refresh_token',
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        biometricEnabled: biometricEnabled,
        pinEnabled: pinEnabled,
      );

      await repository.saveSession(session);

      /// =====================================================
      /// EXISTING USER
      /// =====================================================

      if (hasSecurity) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            session: session,
            biometricEnabled: biometricEnabled,
            pinEnabled: pinEnabled,
            biometricValidated: true,
            pinValidated: true,
            appLocked: false,
            clearError: true,
          ),
        );

        if (kDebugMode) {
          debugPrint('LOGIN -> authenticated (existing user)');
        }

        return;
      }

      /// =====================================================
      /// NEW USER
      /// =====================================================

      emit(
        state.copyWith(
          status: AuthStatus.setupSecurity,
          session: session,
          biometricEnabled: biometricEnabled,
          pinEnabled: pinEnabled,
          biometricValidated: false,
          pinValidated: false,
          appLocked: false,
          clearError: true,
        ),
      );

      if (kDebugMode) {
        debugPrint('LOGIN -> setupSecurity');
      }
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
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      await repository.clearSecurity();
      await repository.clearSession();

      /// CLEAR TRANSACTIONS
      if (Hive.isBoxOpen(HiveBoxes.transactions)) {
        await Hive.box<TransactionModel>(HiveBoxes.transactions).clear();
      }

      /// CLEAR EXCHANGE
      if (Hive.isBoxOpen(HiveBoxes.exchangeRates)) {
        await Hive.box<ExchangeRateModel>(HiveBoxes.exchangeRates).clear();
      }

      /// CLEAR BENEFICIARIES
      if (Hive.isBoxOpen(HiveBoxes.beneficiaries)) {
        await Hive.box<BeneficiaryHiveModel>(HiveBoxes.beneficiaries).clear();
      }

      final biometricEnabled = await repository.isBiometricEnabled();

      final pinEnabled = await repository.isPinEnabled();

      emit(
        AuthState.initial().copyWith(
          status: AuthStatus.unauthenticated,
          biometricEnabled: biometricEnabled,
          pinEnabled: pinEnabled,
          appLocked: false,
          biometricValidated: false,
          pinValidated: false,
        ),
      );

      if (kDebugMode) {
        debugPrint('LOGOUT -> unauthenticated');
      }
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  /// =====================================================
  /// SESSION EXPIRED
  /// =====================================================

  Future<void> _onSessionExpiredLogoutRequested(
    SessionExpiredLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await repository.clearSession();

    emit(AuthState.initial().copyWith(status: AuthStatus.unauthenticated));
  }

  /// =====================================================
  /// CHECK SESSION
  /// =====================================================

  Future<void> _onCheckSessionRequested(
    CheckSessionRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final hasSession = await repository.hasValidSession();

      if (!hasSession) {
        emit(AuthState.initial().copyWith(status: AuthStatus.unauthenticated));

        return;
      }

      final session = await repository.getSession();

      if (session == null) {
        emit(AuthState.initial().copyWith(status: AuthStatus.unauthenticated));

        return;
      }

      /// =====================================================
      /// SECURITY FLOW
      /// =====================================================

      if (session.biometricEnabled) {
        emit(
          state.copyWith(
            status: AuthStatus.biometricRequired,
            session: session,
            biometricEnabled: true,
            pinEnabled: session.pinEnabled,
            appLocked: true,
          ),
        );

        return;
      }

      if (session.pinEnabled) {
        emit(
          state.copyWith(
            status: AuthStatus.pinRequired,
            session: session,
            pinEnabled: true,
            biometricEnabled: session.biometricEnabled,
            appLocked: true,
          ),
        );

        return;
      }

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          session: session,
          biometricValidated: true,
          pinValidated: true,
          appLocked: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onEnableBiometricRequested(
    EnableBiometricRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await repository.enableBiometric(event.biometricEnabled);

      emit(state.copyWith(biometricEnabled: event.biometricEnabled));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onAuthenticateBiometricRequested(
    AuthenticateBiometricRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final success = await repository.authenticateWithBiometric();

      if (!success) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: 'Biometric authentication failed',
          ),
        );

        return;
      }

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          biometricValidated: true,
          pinValidated: true,
          appLocked: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onDisableBiometricRequested(
    DisableBiometricRequested event,
    Emitter<AuthState> emit,
  ) async {
    await repository.enableBiometric(false);

    emit(state.copyWith(biometricEnabled: false));
  }

  Future<void> _onEnablePinRequested(
    EnablePinRequested event,
    Emitter<AuthState> emit,
  ) async {
    await repository.enablePin(event.enabled);

    emit(state.copyWith(pinEnabled: event.enabled));
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

      if (currentSession != null) {
        final updatedSession = currentSession.copyWith(
          pinEnabled: true,
          biometricEnabled: event.biometricEnabled,
        );

        await repository.saveSession(updatedSession);

        emit(
          state.copyWith(
            session: updatedSession,
            status: AuthStatus.authenticated,
            pinEnabled: true,
            biometricEnabled: event.biometricEnabled,
            pinValidated: true,
            biometricValidated: event.biometricEnabled,
            appLocked: false,
          ),
        );

        return;
      }

      emit(state.copyWith(status: AuthStatus.authenticated));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onValidatePinRequested(
    ValidatePinRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final isValid = await repository.validatePin(event.pin);

      if (!isValid) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: 'Invalid PIN',
          ),
        );

        return;
      }

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          pinValidated: true,
          biometricValidated: true,
          appLocked: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onClearSecurityRequested(
    ClearSecurityRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(biometricValidated: false, pinValidated: false));
  }

  Future<void> _onLockAppRequested(
    LockAppRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.status == AuthStatus.unauthenticated) return;

    if (!state.hasSecurityEnabled) return;

    emit(
      state.copyWith(
        status: AuthStatus.locked,
        appLocked: true,
        biometricValidated: false,
        pinValidated: false,
      ),
    );
  }

  Future<void> _onUnlockAppRequested(
    UnlockAppRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        appLocked: false,
        biometricValidated: true,
        pinValidated: true,
      ),
    );
  }

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
      ),
    );
  }

  Future<void> _onResetAuthErrorRequested(
    ResetAuthErrorRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(clearError: true));
  }
}
