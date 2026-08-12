class AppException implements Exception {
  final String message;
  final String? details;
  final String? suggestedFix;
  final dynamic originalError;

  AppException({
    required this.message,
    this.details,
    this.suggestedFix,
    this.originalError,
  });

  @override
  String toString() => message;

  String toDetailedString() {
    final buffer = StringBuffer(message);
    if (details != null) {
      buffer.write('\n\nDetails: $details');
    }
    if (suggestedFix != null) {
      buffer.write('\n\nSuggested Fix: $suggestedFix');
    }
    return buffer.toString();
  }
}

class AdbException extends AppException {
  AdbException({
    required super.message,
    super.details,
    super.suggestedFix,
    super.originalError,
  });
}

class DeviceException extends AppException {
  DeviceException({
    required super.message,
    super.details,
    super.suggestedFix,
    super.originalError,
  });
}

class ConnectionException extends AppException {
  ConnectionException({
    required super.message,
    super.details,
    super.suggestedFix,
    super.originalError,
  });
}

class MirroringException extends AppException {
  MirroringException({
    required super.message,
    super.details,
    super.suggestedFix,
    super.originalError,
  });
}

class PermissionException extends AppException {
  PermissionException({
    required super.message,
    super.details,
    super.suggestedFix,
    super.originalError,
  });
}
