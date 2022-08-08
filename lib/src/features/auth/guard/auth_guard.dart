// ignore_for_file: sort_constructors_first

import 'dart:convert';

import 'package:pets_adventure_backend/src/core/service/jwt/jwt_service.dart';
import 'package:pets_adventure_backend/src/core/service/request_extractor/request_extractor.dart';
import 'package:pets_adventure_backend/src/features/user/enum/role_user_enum.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AuthGuard extends ModularMiddleware {
  final List<RoleUserEnum> roles;
  final bool isRefreshToken;

  AuthGuard({this.roles = const [], this.isRefreshToken = false});

  @override
  Handler call(Handler handler, [ModularRoute? route]) {
    final extrator = Modular.get<RequestExtractor>();
    final jwt = Modular.get<JwtService>();
    return (request) {
      if (!request.headers.containsKey('authorization')) {
        return Response.forbidden(
            jsonEncode({'error': 'not authorization header'}));
      }
      final token = extrator.getAuthorizationBearer(request);
      try {
        jwt.verifyToken(token, isRefreshToken ? 'refreshToken' : 'accessToken');
        final payload = jwt.getPayload(token);
        final role = payload['role'] ?? 'user';
        if (roles.isEmpty || roles.toString().contains(role)) {
          return handler(request);
        }
        return Response.forbidden(
            jsonEncode({'error': 'role ($role) not allowed'}));
      } catch (e) {
        return Response.forbidden(jsonEncode({'error': e.toString()}));
      }
    };
  }
}
