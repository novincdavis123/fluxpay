import '../repositories/auth_repository.dart';

class ValidateSessionUseCase {
  final AuthRepository repository;

  ValidateSessionUseCase(this.repository);

  Future<bool> call() async {
    return repository.hasValidSession();
  }
}
