import '../../domain/entities/auth_session.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.accessToken,
    required super.refreshToken,
    required super.expiresAt,
    required super.biometricEnabled,
    required super.pinEnabled,
  });

  factory AuthSessionModel.fromEntity(AuthSession entity) {
    return AuthSessionModel(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
      expiresAt: entity.expiresAt,
      biometricEnabled: entity.biometricEnabled,
      pinEnabled: entity.pinEnabled,
    );
  }

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      expiresAt: DateTime.parse(json['expires_at']),
      biometricEnabled: json['biometric_enabled'] ?? false,
      pinEnabled: json['pin_enabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.toIso8601String(),
      'biometric_enabled': biometricEnabled,
      'pin_enabled': pinEnabled,
    };
  }

  AuthSession toEntity() {
    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
      biometricEnabled: biometricEnabled,
      pinEnabled: pinEnabled,
    );
  }

  AuthSessionModel copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    bool? biometricEnabled,
    bool? pinEnabled,
  }) {
    return AuthSessionModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      pinEnabled: pinEnabled ?? this.pinEnabled,
    );
  }
}
