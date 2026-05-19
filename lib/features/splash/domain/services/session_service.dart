import 'package:fluxpay/features/auth/domain/entities/auth_session.dart';

abstract class SessionService {
  /// =====================================================
  /// SESSION
  /// =====================================================

  Future<bool> hasSession();

  Future<AuthSession?> getSession();

  Future<void> saveSession(AuthSession session);

  Future<void> clearSession();

  /// =====================================================
  /// VALIDATION
  /// =====================================================

  Future<bool> isTokenExpired();

  Future<bool> isAuthenticated();

  /// =====================================================
  /// SECURITY
  /// =====================================================

  Future<bool> isBiometricEnabled();

  Future<bool> isPinEnabled();

  Future<void> enableBiometric(bool enabled);

  Future<void> enablePin(bool enabled);
}
