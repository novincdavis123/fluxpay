import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_session.dart';

enum AuthStatus {
  initial,
  loading,

  /// =====================================================
  /// AUTH STATES
  /// =====================================================
  authenticated,
  unauthenticated,

  /// =====================================================
  /// SECURITY STATES
  /// =====================================================
  pinRequired,
  biometricRequired,
  setupSecurity,

  /// =====================================================
  /// APP LOCK
  /// =====================================================
  locked,

  /// =====================================================
  /// ERROR
  /// =====================================================
  failure,
}

class AuthState extends Equatable {
  final AuthStatus status;

  final AuthSession? session;

  final String? errorMessage;

  /// =====================================================
  /// SECURITY FLAGS
  /// =====================================================

  final bool biometricEnabled;

  final bool pinEnabled;

  final bool pinValidated;

  final bool biometricValidated;

  /// =====================================================
  /// APP LOCK FLAG
  /// =====================================================

  final bool appLocked;

  const AuthState({
    this.status = AuthStatus.initial,
    this.session,
    this.errorMessage,
    this.biometricEnabled = false,
    this.pinEnabled = false,
    this.pinValidated = false,
    this.biometricValidated = false,
    this.appLocked = false,
  });

  /// =====================================================
  /// COPY WITH
  /// =====================================================

  AuthState copyWith({
    AuthStatus? status,
    AuthSession? session,
    String? errorMessage,
    bool? biometricEnabled,
    bool? pinEnabled,
    bool? pinValidated,
    bool? biometricValidated,
    bool? appLocked,
    bool clearSession = false,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,

      session: clearSession ? null : (session ?? this.session),

      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),

      biometricEnabled: biometricEnabled ?? this.biometricEnabled,

      pinEnabled: pinEnabled ?? this.pinEnabled,

      pinValidated: pinValidated ?? this.pinValidated,

      biometricValidated: biometricValidated ?? this.biometricValidated,

      appLocked: appLocked ?? this.appLocked,
    );
  }

  /// =====================================================
  /// BASIC HELPERS
  /// =====================================================

  bool get isInitial => status == AuthStatus.initial;

  bool get isLoading => status == AuthStatus.loading;

  bool get hasError => status == AuthStatus.failure;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  bool get isUnauthenticated => status == AuthStatus.unauthenticated;

  bool get hasActiveSession => session != null;

  /// =====================================================
  /// SECURITY HELPERS
  /// =====================================================

  bool get hasSecurityEnabled => biometricEnabled || pinEnabled;

  bool get requiresPin => status == AuthStatus.pinRequired;

  bool get requiresBiometric => status == AuthStatus.biometricRequired;

  bool get requiresSecuritySetup => status == AuthStatus.setupSecurity;

  bool get securityValidated => pinValidated || biometricValidated;

  /// =====================================================
  /// LOCK HELPERS
  /// =====================================================

  bool get isLocked => status == AuthStatus.locked || appLocked;

  bool get shouldShowLockScreen =>
      hasSecurityEnabled && (isLocked || requiresPin || requiresBiometric);

  /// =====================================================
  /// ACCESS CONTROL
  /// =====================================================

  bool get canAccessApp =>
      isAuthenticated &&
      !isLocked &&
      (securityValidated || !hasSecurityEnabled);

  /// =====================================================
  /// INITIAL FACTORY
  /// =====================================================

  factory AuthState.initial() {
    return const AuthState(
      status: AuthStatus.initial,
      biometricEnabled: false,
      pinEnabled: false,
      pinValidated: false,
      biometricValidated: false,
      appLocked: false,
    );
  }

  @override
  List<Object?> get props => [
    status,
    session,
    errorMessage,
    biometricEnabled,
    pinEnabled,
    pinValidated,
    biometricValidated,
    appLocked,
  ];
}
