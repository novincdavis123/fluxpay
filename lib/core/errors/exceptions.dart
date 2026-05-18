class ServerException implements Exception {
  final String message;

  const ServerException([this.message = 'Server error occurred']);

  @override
  String toString() {
    return message;
  }
}

class CacheException implements Exception {
  final String message;

  const CacheException([this.message = 'Cache error occurred']);

  @override
  String toString() {
    return message;
  }
}

class NetworkException implements Exception {
  final String message;

  const NetworkException([this.message = 'Network connection failed']);

  @override
  String toString() {
    return message;
  }
}

class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException([this.message = 'Unauthorized access']);

  @override
  String toString() {
    return message;
  }
}

class ValidationException implements Exception {
  final String message;

  const ValidationException([this.message = 'Validation failed']);

  @override
  String toString() {
    return message;
  }
}

class UnknownException implements Exception {
  final String message;

  const UnknownException([this.message = 'Unknown error occurred']);

  @override
  String toString() {
    return message;
  }
}
