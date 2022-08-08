// ignore_for_file: sort_constructors_first

import 'package:pets_adventure_backend/src/core/service/database/remote_database.dart';
import 'package:pets_adventure_backend/src/features/user/interface/user_data_source.dart';

class UserDataSourceImpl implements UserDataSource {
  final RemoteDatabase database;

  UserDataSourceImpl(this.database);

  @override
  Future<List<Map<String, dynamic>>> findAll() async {
    final result = await database.query('SELECT * FROM "User"');
    return result
        .map((element) => element['User'] as Map<String, dynamic>)
        .toList();
  }

  @override
  Future<Map<String, dynamic>> findByEmail(String email) async {
    final result = await database.query(
      'SELECT * FROM "User" WHERE email = @email;',
      variables: {'email': email},
    );
    if (result.isEmpty) {
      return {};
    }
    return result.map((element) => element['User']).first!;
  }

  @override
  Future<Map<String, dynamic>> findById(int id) async {
    final result = await database.query(
      'SELECT * FROM "User" WHERE id = @id;',
      variables: {'id': id},
    );
    if (result.isEmpty) {
      return {};
    }
    return result.map((element) => element['User']).first!;
  }

  @override
  Future<Map<String, dynamic>> findByName(String name) async {
    final result = await database.query(
      'SELECT * FROM "User" WHERE name = @name;',
      variables: {'name': name},
    );
    if (result.isEmpty) {
      return {};
    }
    return result.map((element) => element['User']).first!;
  }

  @override
  Future<void> deleteById(int id) async {
    await database.query(
      'DELETE FROM "User" WHERE id = @id;',
      variables: {'id': id},
    );
  }

  @override
  Future<Map<String, dynamic>> save(Map<String, dynamic> data) async {
    final result = await database.query(
      'INSERT INTO "User" (email, password) VALUES (@email, @password ) RETURNING *',
      variables: data,
    );
    return result.map((element) => element['User']).first!;
  }

  @override
  Future<Map<String, dynamic>> updateName(Map<String, dynamic> data) async {
    final result = await database.query(
      'UPDATE "User" SET name=@name WHERE id=@id RETURNING *',
      variables: data,
    );
    return result.map((element) => element['User']).first!;
  }
}
