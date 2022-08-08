// ignore_for_file: sort_constructors_first

import 'package:pets_adventure_backend/src/core/exception/global_exception.dart';
import 'package:pets_adventure_backend/src/core/service/bcrypt/bcrypt_service.dart';
import 'package:pets_adventure_backend/src/core/service/jwt/jwt_service.dart';
import 'package:pets_adventure_backend/src/core/service/request_extractor/request_extractor.dart';
import 'package:pets_adventure_backend/src/features/auth/interface/auth_data_source.dart';
import 'package:pets_adventure_backend/src/features/auth/model/tokenization_model.dart';

class AuthRepository {
  final BCryptService bcrypt;
  final JwtService jwt;
  final AuthDataSource dataSource;

  AuthRepository(this.dataSource, this.bcrypt, this.jwt);

  Future<TokenizationModel> login(LoginCredential credential) async {
    final userMap = await dataSource.getIdAndRoleByEmail(credential.email);
    if (userMap.isEmpty) {
      throw GlobalException(403, 'Email ou senha invalida');
    }
    if (!bcrypt.checkHash(credential.password, userMap['password'])) {
      throw GlobalException(403, 'Email ou senha invalida');
    }
    final payload = userMap..remove('password');
    return _generateToken(payload);
  }

  Future<TokenizationModel> refreshToken(String token) async {
    final payload = jwt.getPayload(token);
    final role = await dataSource.getRoleById(payload['id']);
    return _generateToken({
      'id': payload['id'],
      'role': role,
    });
  }

  TokenizationModel _generateToken(Map<dynamic, dynamic> payload) {
    payload['exp'] = _determineExpiration(const Duration(hours: 5));
    final accessToken = jwt.generateToken(payload, 'accessToken');
    payload['exp'] = _determineExpiration(const Duration(days: 3));
    final refreshToken = jwt.generateToken(payload, 'refreshToken');
    return TokenizationModel(
        accessToken: accessToken, refreshToken: refreshToken);
  }

  int _determineExpiration(Duration duration) {
    final expiresDate = DateTime.now().add(duration);
    final expiresIn =
        Duration(milliseconds: expiresDate.millisecondsSinceEpoch);
    return expiresIn.inSeconds;
  }

  Future<void> updatePassword(
      String token, String password, String newPassword) async {
    final payload = jwt.getPayload(token);
    final hash = await dataSource.getPasswordById(payload['id']);
    if (!bcrypt.checkHash(password, hash)) {
      throw GlobalException(403, 'senha invalida');
    }
    newPassword = bcrypt.generateHash(newPassword);
    await dataSource.updatePasswordById(payload['id'], newPassword);
  }
}
