// ignore_for_file: sort_constructors_first

import 'dart:convert';

class GlobalException implements Exception {
  final int statusCode;
  final String message;
  final StackTrace? stackTrace;

  GlobalException(this.statusCode, this.message, [this.stackTrace]);

  String toJson() {
    return jsonEncode({'error': message});
  }

  @override
  String toString() =>
      'GlobalException(message: $message, stackTrace: $stackTrace, statusCode: $statusCode)';
}
