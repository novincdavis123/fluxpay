import 'package:fluxpay/features/auth/data/datasource/biometric_datasource.dart';

import '../../domain/repositories/auth_security_repository.dart';

class AuthSecurityRepositoryImpl implements AuthSecurityRepository {
  final BiometricDataSource biometricDataSource;

  const AuthSecurityRepositoryImpl({required this.biometricDataSource});

  @override
  Future<bool> authenticateBiometric() async {
    return biometricDataSource.authenticate();
  }
}
