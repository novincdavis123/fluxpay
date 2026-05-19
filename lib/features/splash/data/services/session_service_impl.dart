import 'package:fluxpay/features/auth/domain/entities/auth_session.dart';

import '../../../../core/security/secure_storage_service.dart';

import '../../domain/services/session_service.dart';

class SessionServiceImpl implements SessionService {
  final SecureStorageService secureStorage;

  SessionServiceImpl(this.secureStorage);

  @override
  Future<bool> hasSession() async {
    final token = await secureStorage.getToken();

    return token != null && token.isNotEmpty;
  }

  @override
  Future<bool> isAuthenticated() async {
    final hasValidToken = await hasSession();

    if (!hasValidToken) {
      return false;
    }

    final expired = await isTokenExpired();

    return !expired;
  }

  @override
  Future<AuthSession?> getSession() async {
    final token = await secureStorage.getToken();

    if (token == null || token.isEmpty) {
      return null;
    }

    return AuthSession(
      accessToken: token,
      refreshToken: '',
      expiresAt: DateTime.now().add(const Duration(days: 7)),
      biometricEnabled: await isBiometricEnabled(),
      pinEnabled: await isPinEnabled(),
    );
  }

  @override
  Future<void> saveSession(AuthSession session) async {
    await secureStorage.saveToken(session.accessToken);
  }

  @override
  Future<void> clearSession() async {
    await secureStorage.clearAll();
  }

  @override
  Future<bool> isBiometricEnabled() async {
    return secureStorage.isBiometricEnabled();
  }

  @override
  Future<void> enableBiometric(bool enabled) async {
    await secureStorage.setBiometricEnabled(enabled);
  }

  @override
  Future<bool> isPinEnabled() async {
    return secureStorage.isPinEnabled();
  }

  @override
  Future<void> enablePin(bool enabled) async {
    await secureStorage.setPinEnabled(enabled);
  }

  @override
  Future<bool> isTokenExpired() async {
    /// MOCK LOGIC FOR NOW
    /// Later decode JWT expiry timestamp

    return false;
  }

  @override
  Future<void> savePin(String pin) async {
    await secureStorage.savePin(pin);
  }

  @override
  Future<bool> validatePin(String pin) async {
    final savedPin = await secureStorage.getPin();

    return savedPin == pin;
  }
}
