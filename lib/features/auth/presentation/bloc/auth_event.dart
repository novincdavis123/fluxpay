import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// =====================================================
/// APP START / SESSION CHECK
/// =====================================================

class CheckSessionRequested extends AuthEvent {
  const CheckSessionRequested();
}

/// =====================================================
/// LOGIN
/// =====================================================

class LoginRequested extends AuthEvent {
  final String email;

  final String password;

  /// =====================================================
  /// IMPORTANT
  /// USED TO DETECT MANUAL LOGOUT LOGIN
  /// =====================================================

  final bool forceSecuritySetup;

  const LoginRequested({
    required this.email,
    required this.password,
    this.forceSecuritySetup = false,
  });

  @override
  List<Object?> get props => [email, password, forceSecuritySetup];
}

/// =====================================================
/// LOGOUT
/// =====================================================

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// =====================================================
/// SESSION EXPIRED LOGOUT
/// AUTO LOGOUT AFTER INACTIVITY
/// =====================================================

class SessionExpiredLogoutRequested extends AuthEvent {
  const SessionExpiredLogoutRequested();
}

/// =====================================================
/// BIOMETRIC AUTHENTICATION
/// =====================================================

class AuthenticateBiometricRequested extends AuthEvent {
  const AuthenticateBiometricRequested();
}

/// =====================================================
/// ENABLE BIOMETRIC
/// =====================================================

class EnableBiometricRequested extends AuthEvent {
  final bool biometricEnabled;

  const EnableBiometricRequested({required this.biometricEnabled});

  @override
  List<Object?> get props => [biometricEnabled];
}

/// =====================================================
/// DISABLE BIOMETRIC
/// =====================================================

class DisableBiometricRequested extends AuthEvent {
  const DisableBiometricRequested();
}

/// =====================================================
/// ENABLE / DISABLE PIN
/// =====================================================

class EnablePinRequested extends AuthEvent {
  final bool enabled;

  const EnablePinRequested({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

/// =====================================================
/// SAVE PIN
/// =====================================================

class SavePinRequested extends AuthEvent {
  final String pin;

  final bool biometricEnabled;

  const SavePinRequested({required this.pin, this.biometricEnabled = false});

  @override
  List<Object?> get props => [pin, biometricEnabled];
}

/// =====================================================
/// VALIDATE PIN
/// =====================================================

class ValidatePinRequested extends AuthEvent {
  final String pin;

  const ValidatePinRequested({required this.pin});

  @override
  List<Object?> get props => [pin];
}

/// =====================================================
/// CLEAR SECURITY FLAGS
/// =====================================================

class ClearSecurityRequested extends AuthEvent {
  const ClearSecurityRequested();
}

/// =====================================================
/// LOCK APP
/// Triggered after inactivity
/// =====================================================

class LockAppRequested extends AuthEvent {
  const LockAppRequested();
}

/// =====================================================
/// UNLOCK APP
/// Triggered after successful auth
/// =====================================================

class UnlockAppRequested extends AuthEvent {
  const UnlockAppRequested();
}

/// =====================================================
/// FORCE AUTHENTICATED
/// =====================================================

class MarkAuthenticatedRequested extends AuthEvent {
  const MarkAuthenticatedRequested();
}

/// =====================================================
/// RESET AUTH ERROR
/// =====================================================

class ResetAuthErrorRequested extends AuthEvent {
  const ResetAuthErrorRequested();
}

/// =====================================================
/// SESSION EXPIRED
/// =====================================================

class SessionExpiredRequested extends AuthEvent {
  const SessionExpiredRequested();
}

/// =====================================================
/// REFRESH SESSION
/// =====================================================

class RefreshSessionRequested extends AuthEvent {
  const RefreshSessionRequested();
}
