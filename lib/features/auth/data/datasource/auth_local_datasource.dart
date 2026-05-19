import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:local_auth/local_auth.dart';

import '../models/auth_session_model.dart';

abstract class AuthLocalDataSource {
  /// =====================================================
  /// SESSION
  /// =====================================================

  Future<void> saveSession(AuthSessionModel session);

  Future<AuthSessionModel?> getSession();

  Future<void> clearSession();

  /// =====================================================
  /// BIOMETRIC
  /// =====================================================

  Future<bool> isBiometricAvailable();

  Future<bool> authenticateWithBiometric();

  Future<void> setBiometricEnabled(bool enabled);

  Future<bool> isBiometricEnabled();

  /// =====================================================
  /// PIN ENABLED
  /// =====================================================

  Future<void> setPinEnabled(bool enabled);

  Future<bool> isPinEnabled();

  /// =====================================================
  /// PIN
  /// =====================================================

  Future<void> savePin(String pin);

  Future<bool> validatePin(String pin);

  Future<void> clearPin();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;

  final LocalAuthentication localAuth;

  const AuthLocalDataSourceImpl(this.storage, this.localAuth);

  /// =====================================================
  /// STORAGE KEYS
  /// =====================================================

  static const String _sessionKey = 'auth_session';

  static const String _biometricKey = 'biometric_enabled';

  static const String _pinEnabledKey = 'pin_enabled';

  static const String _userPinKey = 'user_pin';

  /// =====================================================
  /// SESSION
  /// =====================================================

  @override
  Future<void> saveSession(AuthSessionModel session) async {
    await storage.write(key: _sessionKey, value: jsonEncode(session.toJson()));
  }

  @override
  Future<AuthSessionModel?> getSession() async {
    final raw = await storage.read(key: _sessionKey);

    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);

      return AuthSessionModel.fromJson(decoded);
    } catch (_) {
      await clearSession();

      return null;
    }
  }

  @override
  Future<void> clearSession() async {
    await storage.delete(key: _sessionKey);
  }

  /// =====================================================
  /// BIOMETRIC
  /// =====================================================

  @override
  Future<bool> isBiometricAvailable() async {
    try {
      final canCheckBiometrics = await localAuth.canCheckBiometrics;

      final isDeviceSupported = await localAuth.isDeviceSupported();

      return canCheckBiometrics && isDeviceSupported;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> authenticateWithBiometric() async {
    try {
      final authenticated = await localAuth.authenticate(
        localizedReason: 'Authenticate to access FluxPay',
      );

      return authenticated;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    await storage.write(key: _biometricKey, value: enabled.toString());
  }

  @override
  Future<bool> isBiometricEnabled() async {
    final value = await storage.read(key: _biometricKey);

    return value == 'true';
  }

  /// =====================================================
  /// PIN ENABLED
  /// =====================================================

  @override
  Future<void> setPinEnabled(bool enabled) async {
    await storage.write(key: _pinEnabledKey, value: enabled.toString());
  }

  @override
  Future<bool> isPinEnabled() async {
    final value = await storage.read(key: _pinEnabledKey);

    return value == 'true';
  }

  /// =====================================================
  /// PIN
  /// =====================================================

  @override
  Future<void> savePin(String pin) async {
    await storage.write(key: _userPinKey, value: pin);
  }

  @override
  Future<bool> validatePin(String pin) async {
    final savedPin = await storage.read(key: _userPinKey);

    return savedPin == pin;
  }

  @override
  Future<void> clearPin() async {
    await storage.delete(key: _userPinKey);
  }
}
