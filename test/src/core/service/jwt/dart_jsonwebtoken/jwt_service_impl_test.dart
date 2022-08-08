// ignore_for_file: avoid_print

import 'package:pets_adventure_backend/src/core/service/jwt/dart_jsonwebtoken/jwt_service_impl.dart';
import 'package:test/test.dart';

void main() {
  test('jwt create', () async {
    final jwt = JwtServiceImpl();
    final expiresDate = DateTime.now().add(const Duration(seconds: 30));
    final expiresIn =
        Duration(milliseconds: expiresDate.millisecondsSinceEpoch).inSeconds;
    final token = jwt.generateToken({
      'id': 1,
      'role': 'user',
      'exp': expiresIn,
    }, 'accessToken');
    print(token);
  });

  test('jwt verify', () async {
    JwtServiceImpl().verifyToken(
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6IlVTRVIiLCJleHAiOjE2NTk4NzkwMjMsImlhdCI6MTY1OTg3ODk5MywiYXVkIjoiYWNjZXNzVG9rZW4ifQ.7EzcTf3yxR17F4AWCjNeUn45_Y6fl_cpPNMg3FEkiWw',
      'accessToken',
    );
  });

  test('jwt payload', () async {
    final jwt = JwtServiceImpl();
    final payload = jwt.getPayload(
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6IlVTRVIiLCJleHAiOjE2NTk4NzkwMjMsImlhdCI6MTY1OTg3ODk5MywiYXVkIjoiYWNjZXNzVG9rZW4ifQ.7EzcTf3yxR17F4AWCjNeUn45_Y6fl_cpPNMg3FEkiWw',
    );
    print(payload);
  });
}
