import 'dart:async';

import 'package:pets_adventure_backend/src/core/service/database/remote_database.dart';
import 'package:pets_adventure_backend/src/core/service/dot_env/dot_env_service.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf_modular/shelf_modular.dart';

class PostgresDatabase implements RemoteDatabase, Disposable {
  PostgresDatabase(this._dotEnvService) {
    _init();
  }

  final _completer = Completer<PostgreSQLConnection>();
  final DotEnvService _dotEnvService;

  Future<void> _init() async {
    final url = _dotEnvService['DATABASE_URL']!;
    final uri = Uri.parse(url);
    final connection = PostgreSQLConnection(
      uri.host,
      uri.port,
      uri.pathSegments.first,
      username: uri.userInfo.split(':').first,
      password: uri.userInfo.split(':').last,
      useSSL: true,
    );
    await connection.open();
    _completer.complete(connection);
  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> query(
    String queryText, {
    Map<String, dynamic> variables = const {},
  }) async {
    final connection = await _completer.future;
    return connection.mappedResultsQuery(
      queryText,
      substitutionValues: variables,
    );
  }

  @override
  Future<void> dispose() async {
    final connection = await _completer.future;
    await connection.close();
  }
}
