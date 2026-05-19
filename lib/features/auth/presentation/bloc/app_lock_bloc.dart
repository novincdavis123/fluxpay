import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';

import '../../domain/usecases/authenticate_biometric_usecase.dart';

import 'app_lock_event.dart';
import 'app_lock_state.dart';

class AppLockBloc extends Bloc<AppLockEvent, AppLockState> {
  final AuthenticateBiometricUseCase biometricUseCase;

  final AuthRepository authRepository;

  AppLockBloc({required this.biometricUseCase, required this.authRepository})
    : super(const AppLockState(status: AppLockStatus.locked)) {
    on<UnlockWithBiometric>(_onUnlockWithBiometric);

    on<UnlockWithPin>(_onUnlockWithPin);

    on<LockAppRequested>(_onLockAppRequested);

    on<ResetLockStateRequested>(_onResetLockStateRequested);
  }

  /// =====================================================
  /// BIOMETRIC UNLOCK
  /// =====================================================

  Future<void> _onUnlockWithBiometric(
    UnlockWithBiometric event,
    Emitter<AppLockState> emit,
  ) async {
    emit(state.copyWith(status: AppLockStatus.loading, clearError: true));

    try {
      final success = await biometricUseCase();

      if (success) {
        emit(state.copyWith(status: AppLockStatus.unlocked, clearError: true));

        return;
      }

      emit(
        state.copyWith(
          status: AppLockStatus.failure,
          errorMessage: 'Biometric authentication failed',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppLockStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// =====================================================
  /// PIN UNLOCK
  /// =====================================================

  Future<void> _onUnlockWithPin(
    UnlockWithPin event,
    Emitter<AppLockState> emit,
  ) async {
    emit(state.copyWith(status: AppLockStatus.loading, clearError: true));

    try {
      final isValid = await authRepository.validatePin(event.pin);

      if (isValid) {
        emit(state.copyWith(status: AppLockStatus.unlocked, clearError: true));

        return;
      }

      emit(
        state.copyWith(
          status: AppLockStatus.failure,
          errorMessage: 'Invalid PIN',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppLockStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// =====================================================
  /// LOCK APP
  /// =====================================================

  Future<void> _onLockAppRequested(
    LockAppRequested event,
    Emitter<AppLockState> emit,
  ) async {
    emit(state.copyWith(status: AppLockStatus.locked, clearError: true));
  }

  /// =====================================================
  /// RESET STATE
  /// =====================================================

  Future<void> _onResetLockStateRequested(
    ResetLockStateRequested event,
    Emitter<AppLockState> emit,
  ) async {
    emit(state.copyWith(status: AppLockStatus.locked, clearError: true));
  }
}
