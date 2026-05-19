import 'package:fluxpay/features/auth/data/datasource/auth_local_datasource.dart';

import 'package:fluxpay/features/auth/data/models/auth_session_model.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({required this.localDataSource});

  /// =====================================================
  /// SESSION
  /// =====================================================

  @override
  Future<AuthSession?> getSession() async {
    try {
      final session = await localDataSource.getSession();

      if (session == null) {
        return null;
      }

      /// =====================================================
      /// RESTORE SECURITY FLAGS
      /// IMPORTANT AFTER APP RESTART
      /// =====================================================

      final biometricEnabled = await localDataSource.isBiometricEnabled();

      final pinEnabled = await localDataSource.isPinEnabled();

      return AuthSession(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
        expiresAt: session.expiresAt,
        biometricEnabled: biometricEnabled,
        pinEnabled: pinEnabled,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveSession(AuthSession session) async {
    final model = AuthSessionModel(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      expiresAt: session.expiresAt,
      biometricEnabled: session.biometricEnabled,
      pinEnabled: session.pinEnabled,
    );

    /// =====================================================
    /// SAVE SESSION
    /// =====================================================

    await localDataSource.saveSession(model);

    /// =====================================================
    /// SAVE SECURITY FLAGS SEPARATELY
    /// =====================================================

    await localDataSource.setBiometricEnabled(session.biometricEnabled);

    await localDataSource.setPinEnabled(session.pinEnabled);
  }

  @override
  Future<void> clearSession() async {
    await localDataSource.clearSession();
  }

  /// =====================================================
  /// AUTH STATUS
  /// =====================================================

  @override
  Future<bool> hasValidSession() async {
    try {
      final session = await localDataSource.getSession();

      /// =====================================================
      /// NO SESSION
      /// =====================================================

      if (session == null) {
        return false;
      }

      /// =====================================================
      /// INVALID TOKEN
      /// =====================================================

      if (session.accessToken.isEmpty) {
        return false;
      }

      /// =====================================================
      /// EXPIRED SESSION
      /// =====================================================

      final now = DateTime.now();

      if (session.expiresAt.isBefore(now)) {
        await clearSession();

        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await hasValidSession();
  }

  /// =====================================================
  /// BIOMETRIC
  /// =====================================================

  @override
  Future<bool> isBiometricAvailable() async {
    return await localDataSource.isBiometricAvailable();
  }

  @override
  Future<bool> authenticateWithBiometric() async {
    return await localDataSource.authenticateWithBiometric();
  }

  @override
  Future<bool> isBiometricEnabled() async {
    return await localDataSource.isBiometricEnabled();
  }

  @override
  Future<void> enableBiometric(bool enabled) async {
    /// =====================================================
    /// SAVE BOOLEAN FLAG
    /// =====================================================

    await localDataSource.setBiometricEnabled(enabled);

    /// =====================================================
    /// UPDATE SESSION
    /// =====================================================

    final session = await localDataSource.getSession();

    if (session == null) {
      return;
    }

    final updated = AuthSessionModel(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      expiresAt: session.expiresAt,
      biometricEnabled: enabled,
      pinEnabled: session.pinEnabled,
    );

    await localDataSource.saveSession(updated);
  }

  /// =====================================================
  /// PIN
  /// =====================================================

  @override
  Future<bool> isPinEnabled() async {
    return await localDataSource.isPinEnabled();
  }

  @override
  Future<void> enablePin(bool enabled) async {
    /// =====================================================
    /// SAVE BOOLEAN FLAG
    /// =====================================================

    await localDataSource.setPinEnabled(enabled);

    /// =====================================================
    /// UPDATE SESSION
    /// =====================================================

    final session = await localDataSource.getSession();

    if (session == null) {
      return;
    }

    final updated = AuthSessionModel(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      expiresAt: session.expiresAt,
      biometricEnabled: session.biometricEnabled,
      pinEnabled: enabled,
    );

    await localDataSource.saveSession(updated);
  }

  @override
  Future<void> savePin(String pin) async {
    await localDataSource.savePin(pin);
  }

  @override
  Future<bool> validatePin(String pin) async {
    return await localDataSource.validatePin(pin);
  }

  @override
  Future<void> clearPin() async {
    await localDataSource.clearPin();
  }

  /// =====================================================
  /// SECURITY
  /// =====================================================

  @override
  Future<void> clearSecurity() async {
    await localDataSource.setBiometricEnabled(false);

    await localDataSource.setPinEnabled(false);

    await localDataSource.clearPin();

    /// =====================================================
    /// UPDATE SESSION
    /// =====================================================

    final session = await localDataSource.getSession();

    if (session == null) {
      return;
    }

    final updated = AuthSessionModel(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      expiresAt: session.expiresAt,
      biometricEnabled: false,
      pinEnabled: false,
    );

    await localDataSource.saveSession(updated);
  }

  @override
  Future<bool> hasSecuritySetup() async {
    final biometricEnabled = await localDataSource.isBiometricEnabled();

    final pinEnabled = await localDataSource.isPinEnabled();

    return biometricEnabled || pinEnabled;
  }
}
