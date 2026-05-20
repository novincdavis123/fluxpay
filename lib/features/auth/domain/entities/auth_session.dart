class AuthSession {
  final String accessToken;

  final String refreshToken;

  final DateTime expiresAt;

  final bool biometricEnabled;

  final bool pinEnabled;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.biometricEnabled,
    required this.pinEnabled,
  });

  bool get isExpired {
    return DateTime.now().isAfter(expiresAt);
  }

  /// =====================================================
  /// COPY WITH
  /// =====================================================

  AuthSession copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    bool? biometricEnabled,
    bool? pinEnabled,
  }) {
    return AuthSession(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      pinEnabled: pinEnabled ?? this.pinEnabled,
    );
  }
}
