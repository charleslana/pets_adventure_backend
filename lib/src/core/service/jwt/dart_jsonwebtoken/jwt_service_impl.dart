// ignore_for_file: sort_constructors_first

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:pets_adventure_backend/src/core/service/dot_env/dot_env_service.dart';
import 'package:pets_adventure_backend/src/core/service/jwt/jwt_service.dart';

class JwtServiceImpl implements JwtService {
  final DotEnvService dotEnvService;

  JwtServiceImpl(this.dotEnvService);

  @override
  String generateToken(Map<dynamic, dynamic> claims, String audience) {
    final jwt = JWT(claims, audience: Audience.one(audience));
    final token = jwt.sign(SecretKey(dotEnvService['JWT_KEY']!));
    return token;
  }

  @override
  void verifyToken(String token, String audience) {
    JWT.verify(
      token,
      SecretKey(dotEnvService['JWT_KEY']!),
      audience: Audience.one(audience),
    );
  }

  @override
  Map<dynamic, dynamic> getPayload(String token) {
    final jwt = JWT.verify(
      token,
      SecretKey(dotEnvService['JWT_KEY']!),
      checkExpiresIn: false,
      checkHeaderType: false,
      checkNotBefore: false,
    );
    return jwt.payload;
  }
}
