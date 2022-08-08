// ignore_for_file: sort_constructors_first

import 'dart:convert';

class ResponseDto {
  final int statusCode;
  final String message;

  ResponseDto(
    this.statusCode,
    this.message,
  );

  String toJson() {
    return jsonEncode({'success': message});
  }

  @override
  String toString() =>
      'ResponseDto(message: $message, statusCode: $statusCode)';
}
