import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  /// =====================================================
  /// STORAGE KEYS
  /// =====================================================

  static const _tokenKey = 'auth_token';

  static const _refreshTokenKey = 'refresh_token';

  static const _pinKey = 'user_pin';

  static const _pinEnabledKey = 'pin_enabled';

  static const _biometricEnabledKey = 'biometric_enabled';

  static const _lastLoginKey = 'last_login';

  /// =====================================================
  /// TOKEN
  /// =====================================================

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// =====================================================
  /// REFRESH TOKEN
  /// =====================================================

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }

  /// =====================================================
  /// PIN
  /// =====================================================

  Future<void> savePin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
  }

  Future<String?> getPin() async {
    return _storage.read(key: _pinKey);
  }

  Future<void> deletePin() async {
    await _storage.delete(key: _pinKey);
  }

  /// =====================================================
  /// PIN ENABLED
  /// =====================================================

  Future<void> setPinEnabled(bool enabled) async {
    await _storage.write(key: _pinEnabledKey, value: enabled.toString());
  }

  Future<bool> isPinEnabled() async {
    final value = await _storage.read(key: _pinEnabledKey);

    return value == 'true';
  }

  /// =====================================================
  /// BIOMETRIC ENABLED
  /// =====================================================

  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: _biometricEnabledKey, value: enabled.toString());
  }

  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _biometricEnabledKey);

    return value == 'true';
  }

  /// =====================================================
  /// LAST LOGIN
  /// =====================================================

  Future<void> saveLastLogin(DateTime date) async {
    await _storage.write(key: _lastLoginKey, value: date.toIso8601String());
  }

  Future<DateTime?> getLastLogin() async {
    final value = await _storage.read(key: _lastLoginKey);

    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  /// =====================================================
  /// CLEAR
  /// =====================================================

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
