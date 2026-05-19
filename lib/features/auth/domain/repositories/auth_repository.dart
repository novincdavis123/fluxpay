import '../entities/auth_session.dart';

abstract class AuthRepository {
  /// =====================================================
  /// SESSION
  /// =====================================================

  Future<AuthSession?> getSession();

  Future<void> saveSession(AuthSession session);

  Future<void> clearSession();

  /// =====================================================
  /// AUTH STATUS
  /// =====================================================

  Future<bool> hasValidSession();

  Future<bool> isAuthenticated();

  /// =====================================================
  /// BIOMETRIC
  /// =====================================================

  Future<bool> isBiometricAvailable();

  Future<bool> authenticateWithBiometric();

  Future<bool> isBiometricEnabled();

  Future<void> enableBiometric(bool enabled);

  /// =====================================================
  /// PIN
  /// =====================================================

  Future<bool> isPinEnabled();

  Future<void> enablePin(bool enabled);

  Future<void> savePin(String pin);

  Future<bool> validatePin(String pin);

  Future<void> clearPin();

  /// =====================================================
  /// SECURITY
  /// =====================================================

  Future<void> clearSecurity();

  Future<bool> hasSecuritySetup();
}
