import '../repositories/auth_security_repository.dart';

class AuthenticateBiometricUseCase {
  final AuthSecurityRepository repository;

  const AuthenticateBiometricUseCase(this.repository);

  Future<bool> call() async {
    return repository.authenticateBiometric();
  }
}
