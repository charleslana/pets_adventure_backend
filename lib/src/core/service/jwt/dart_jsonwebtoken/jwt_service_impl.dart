// ignore_for_file: sort_constructors_first

import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:pets_adventure_backend/src/core/service/dot_env/dot_env_service.dart';
import 'package:pets_adventure_backend/src/core/service/jwt/jwt_service.dart';

class JwtServiceImpl implements JwtService {
  final DotEnvService dotEnvService;

  JwtServiceImpl(this.dotEnvService);

  @override
  String generateToken(Map<dynamic, dynamic> claims, String audience) {
    final jwt = JWT(claims, audience: Audience.one(audience));
    final env = Platform.environment;
    final jwtKey = env.entries.firstWhere((element) => element.key == 'JWT_KEY',
        orElse: () =>
            const MapEntry('JWT_KEY', '1xtguNiWOo9U7zVvEFFTBh5FEyvrQRFqf5'));
    final token = jwt.sign(SecretKey(jwtKey.value));
    return token;
  }

  @override
  void verifyToken(String token, String audience) {
    final env = Platform.environment;
    final jwtKey = env.entries.firstWhere((element) => element.key == 'JWT_KEY',
        orElse: () =>
            const MapEntry('JWT_KEY', '1xtguNiWOo9U7zVvEFFTBh5FEyvrQRFqf5'));
    JWT.verify(
      token,
      SecretKey(jwtKey.value),
      audience: Audience.one(audience),
    );
  }

  @override
  Map<dynamic, dynamic> getPayload(String token) {
    final env = Platform.environment;
    final jwtKey = env.entries.firstWhere((element) => element.key == 'JWT_KEY',
        orElse: () =>
            const MapEntry('JWT_KEY', '1xtguNiWOo9U7zVvEFFTBh5FEyvrQRFqf5'));
    final jwt = JWT.verify(
      token,
      SecretKey(jwtKey.value),
      checkExpiresIn: false,
      checkHeaderType: false,
      checkNotBefore: false,
    );
    return jwt.payload;
  }
}
