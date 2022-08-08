import 'dart:async';

import 'package:pets_adventure_backend/src/core/dto/response_dto.dart';
import 'package:pets_adventure_backend/src/core/exception/global_exception.dart';
import 'package:shelf/shelf.dart';

FutureOr<Response> handleResponseError(GlobalException error) {
  return Response(error.statusCode, body: error.toJson());
}

FutureOr<Response> handleResponseSuccess(ResponseDto dto) {
  return Response(dto.statusCode, body: dto.toJson());
}

bool validateName(String name) {
  return RegExp(r'^[a-zA-Z0-9]([_](?![_])|[a-zA-Z0-9]){1,18}[a-zA-Z0-9]$')
      .hasMatch(name);
}
