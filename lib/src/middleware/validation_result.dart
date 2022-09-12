library go_router_infused.middleware;

import 'package:go_router_infused/src/middleware/middleware.dart' show GoMiddleware;

class MiddlewareValidationResult {
  final String? message;
  final int code;
  final bool isValid;
  final bool canBeIgnored;
  MiddlewareValidationResult({
    this.message,
    required this.canBeIgnored,
    required this.code,
    required this.isValid,
  });

  @override
  String toString() {
    return '''
message: $message, 
code: $code, 
isValid: $isValid, 
canBeIgnored: $canBeIgnored
''';
  }
}

class MiddlewareValidationResultException<T extends GoMiddleware> implements Exception {
  final MiddlewareValidationResult? validationResult;
  final T? sender;
  MiddlewareValidationResultException(
    this.validationResult,
    this.sender,
  );

  @override
  String toString() {
    return '''
an unignorable validator failed
///////////////////////////
sender: 
$sender
///////////////////////////
MiddlewareValidationResult: $validationResult
''';
  }
}
