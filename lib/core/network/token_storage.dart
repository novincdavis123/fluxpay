import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage secureStorage;

  TokenStorage({required this.secureStorage});

  static const _accessTokenKey = 'access_token';

  static const _refreshTokenKey = 'refresh_token';

  static const _accessTokenExpiryKey = 'access_token_expiry';

  /// ACCESS TOKEN
  Future<String?> get accessToken async {
    return await secureStorage.read(key: _accessTokenKey);
  }

  /// REFRESH TOKEN
  Future<String?> get refreshToken async {
    return await secureStorage.read(key: _refreshTokenKey);
  }

  /// ACCESS TOKEN EXPIRY
  Future<DateTime?> get accessTokenExpiry async {
    final value = await secureStorage.read(key: _accessTokenExpiryKey);

    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  /// LOGIN STATUS
  Future<bool> get isLoggedIn async {
    final token = await accessToken;

    final expiry = await accessTokenExpiry;

    if (token == null || expiry == null) {
      return false;
    }

    return !_isTokenExpired(expiry);
  }

  /// SAVE ACCESS TOKEN
  Future<void> saveAccessToken({
    required String token,
    required DateTime expiry,
  }) async {
    await secureStorage.write(key: _accessTokenKey, value: token);

    await secureStorage.write(
      key: _accessTokenExpiryKey,
      value: expiry.toIso8601String(),
    );

    if (kDebugMode) {
      debugPrint('✅ Access token securely saved');
    }
  }

  /// SAVE REFRESH TOKEN
  Future<void> saveRefreshToken(String token) async {
    await secureStorage.write(key: _refreshTokenKey, value: token);

    if (kDebugMode) {
      debugPrint('✅ Refresh token securely saved');
    }
  }

  /// CLEAR TOKENS
  Future<void> clearTokens() async {
    await secureStorage.delete(key: _accessTokenKey);

    await secureStorage.delete(key: _refreshTokenKey);

    await secureStorage.delete(key: _accessTokenExpiryKey);

    if (kDebugMode) {
      debugPrint('🗑 Tokens cleared securely');
    }
  }

  /// CHECK TOKEN EXPIRY
  bool _isTokenExpired(DateTime expiry) {
    return DateTime.now().isAfter(expiry);
  }

  /// CHECK IF TOKEN EXPIRES SOON
  Future<bool> willExpireSoon({int minutes = 5}) async {
    final expiry = await accessTokenExpiry;

    if (expiry == null) {
      return true;
    }

    final remaining = expiry.difference(DateTime.now());

    return remaining.inMinutes <= minutes;
  }

  /// UPDATE ACCESS TOKEN
  Future<void> updateAccessToken({
    required String token,
    required DateTime expiry,
  }) async {
    await saveAccessToken(token: token, expiry: expiry);

    if (kDebugMode) {
      debugPrint('🔄 Access token updated securely');
    }
  }
}
