// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:pets_adventure_backend/src/core/dto/response_dto.dart';
import 'package:pets_adventure_backend/src/core/exception/global_exception.dart';
import 'package:pets_adventure_backend/src/core/service/jwt/jwt_service.dart';
import 'package:pets_adventure_backend/src/core/service/request_extractor/request_extractor.dart';
import 'package:pets_adventure_backend/src/features/auth/guard/auth_guard.dart';
import 'package:pets_adventure_backend/src/features/user/enum/role_user_enum.dart';
import 'package:pets_adventure_backend/src/features/user/model/dto/user_basic_dto.dart';
import 'package:pets_adventure_backend/src/features/user/model/user_model.dart';
import 'package:pets_adventure_backend/src/features/user/repository/user_repository.dart';
import 'package:pets_adventure_backend/src/utils/functions_utils.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UserResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/user', _getAllUser, middlewares: [
          AuthGuard(roles: [RoleUserEnum.admin])
        ]),
        Route.get('/user/:id', _getUserById, middlewares: [
          AuthGuard(roles: [RoleUserEnum.admin])
        ]),
        Route.delete('/user/:id', _deleteUserById, middlewares: [
          AuthGuard(roles: [RoleUserEnum.admin])
        ]),
        Route.post('/user', _createUser),
        Route.put('/user', _updateUserName, middlewares: [AuthGuard()]),
        Route.get('/user/details', _getUserDetails, middlewares: [AuthGuard()]),
      ];

  FutureOr<Response> _createUser(
      ModularArguments arguments, Injector<dynamic> injector) async {
    try {
      final userRepository = injector.get<UserRepository>();
      final result = await userRepository.create(arguments);
      final ResponseDto dto = ResponseDto(201, result);
      return handleResponseSuccess(dto);
    } on GlobalException catch (e) {
      print(e);
      return handleResponseError(e);
    }
  }

  FutureOr<Response> _deleteUserById(
      ModularArguments arguments, Injector<dynamic> injector) async {
    try {
      final userRepository = injector.get<UserRepository>();
      final result = await userRepository.delete(arguments);
      final ResponseDto dto = ResponseDto(200, result);
      return handleResponseSuccess(dto);
    } on GlobalException catch (e) {
      print(e);
      return handleResponseError(e);
    }
  }

  FutureOr<Response> _getAllUser(Injector<dynamic> injector) async {
    try {
      final userRepository = injector.get<UserRepository>();
      final List<UserModel> users = await userRepository.getAll(injector);
      return Response.ok(
          jsonEncode(users.map((user) => user.toMap()).toList()));
    } on GlobalException catch (e) {
      print(e);
      return handleResponseError(e);
    }
  }

  FutureOr<Response> _getUserById(
      ModularArguments arguments, Injector<dynamic> injector) async {
    try {
      final userRepository = injector.get<UserRepository>();
      final UserModel user = await userRepository.get(arguments);
      return Response.ok(jsonEncode(user.toMap()));
    } on GlobalException catch (e) {
      print(e);
      return handleResponseError(e);
    }
  }

  FutureOr<Response> _getUserDetails(ModularArguments arguments,
      Request request, Injector<dynamic> injector) async {
    try {
      final userRepository = injector.get<UserRepository>();
      final extractor = injector.get<RequestExtractor>();
      final token = extractor.getAuthorizationBearer(request);
      final jwt = injector.get<JwtService>();
      final payload = jwt.getPayload(token);
      final UserBasicDto user = await userRepository.getDetails(payload['id']);
      return Response.ok(jsonEncode(user.toMap()));
    } on GlobalException catch (e) {
      print(e);
      return handleResponseError(e);
    }
  }

  FutureOr<Response> _updateUserName(ModularArguments arguments,
      Request request, Injector<dynamic> injector) async {
    try {
      final userRepository = injector.get<UserRepository>();
      final extractor = injector.get<RequestExtractor>();
      final token = extractor.getAuthorizationBearer(request);
      final jwt = injector.get<JwtService>();
      final payload = jwt.getPayload(token);
      arguments.data['id'] = payload['id'];
      final result = await userRepository.updateName(arguments);
      final ResponseDto dto = ResponseDto(200, result);
      return handleResponseSuccess(dto);
    } on GlobalException catch (e) {
      print(e);
      return handleResponseError(e);
    }
  }
}
