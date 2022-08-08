// ignore_for_file: sort_constructors_first

import 'package:pets_adventure_backend/src/core/service/database/remote_database.dart';
import 'package:pets_adventure_backend/src/features/auth/interface/auth_data_source.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final RemoteDatabase database;

  AuthDataSourceImpl(this.database);

  @override
  Future<Map<dynamic, dynamic>> getIdAndRoleByEmail(String email) async {
    final result = await database.query(
      'SELECT id, role, password FROM "User" WHERE email = @email',
      variables: {
        'email': email,
      },
    );
    if (result.isEmpty) {
      return {};
    }
    return result.map((element) => element['User']).first!;
  }

  @override
  Future<String> getRoleById(id) async {
    final result = await database.query(
      'SELECT role FROM "User" WHERE id = @id',
      variables: {
        'id': id,
      },
    );
    return result.map((element) => element['User']).first!['role'];
  }

  @override
  Future<String> getPasswordById(id) async {
    final result = await database.query(
      'SELECT password FROM "User" WHERE id = @id',
      variables: {
        'id': id,
      },
    );
    return result.map((element) => element['User']).first!['password'];
  }

  @override
  Future<void> updatePasswordById(id, String password) async {
    const queryUpdate = 'UPDATE "User" SET password=@password WHERE id=@id';
    await database.query(queryUpdate, variables: {
      'id': id,
      'password': password,
    });
  }
}
