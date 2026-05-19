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

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// =====================================================
/// LOGOUT
/// =====================================================

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
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
/// Triggered when app enters background/inactive
/// =====================================================

class LockAppRequested extends AuthEvent {
  const LockAppRequested();
}

/// =====================================================
/// UNLOCK APP
/// Triggered after successful lockscreen auth
/// =====================================================

class UnlockAppRequested extends AuthEvent {
  const UnlockAppRequested();
}

/// =====================================================
/// FORCE AUTHENTICATED
/// Used after lockscreen validation success
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
