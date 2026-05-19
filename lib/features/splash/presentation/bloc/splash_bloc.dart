import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/features/auth/domain/entities/auth_session.dart';

import 'package:fluxpay/features/auth/domain/repositories/auth_repository.dart';

import 'package:fluxpay/features/auth/domain/usecases/validate_session_usecase.dart';

import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final ValidateSessionUseCase validateSessionUseCase;

  final AuthRepository authRepository;

  SplashBloc(this.validateSessionUseCase, this.authRepository)
    : super(const SplashState()) {
    on<InitializeApp>(_onInitializeApp);
  }

  Future<void> _onInitializeApp(
    InitializeApp event,
    Emitter<SplashState> emit,
  ) async {
    emit(state.copyWith(status: SplashStatus.loading));

    /// SPLASH DELAY
    await Future.delayed(const Duration(milliseconds: 1400));

    try {
      /// VALIDATE SESSION
      final isAuthenticated = await validateSessionUseCase();

      /// NO SESSION
      if (!isAuthenticated) {
        emit(state.copyWith(status: SplashStatus.unauthenticated));

        return;
      }

      /// RESTORE SESSION
      final AuthSession? session = await authRepository.getSession();

      /// SAFETY CHECK
      if (session == null) {
        emit(state.copyWith(status: SplashStatus.unauthenticated));

        return;
      }

      /// SESSION EXPIRED
      if (session.isExpired) {
        await authRepository.clearSession();

        emit(state.copyWith(status: SplashStatus.unauthenticated));

        return;
      }

      /// APP LOCK ENABLED
      if (session.biometricEnabled || session.pinEnabled) {
        emit(state.copyWith(status: SplashStatus.locked));

        return;
      }

      /// AUTHENTICATED
      emit(state.copyWith(status: SplashStatus.authenticated));
    } catch (_) {
      emit(state.copyWith(status: SplashStatus.unauthenticated));
    }
  }
}
