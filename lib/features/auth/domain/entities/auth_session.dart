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
}
