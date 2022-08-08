import 'dart:async';
import 'dart:io';

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
    final env = Platform.environment;
    final databaseUrl = env.entries.firstWhere(
        (element) => element.key == 'DATABASE_URL',
        orElse: () => const MapEntry('DATABASE_URL',
            'postgres://tcmmztggqsabgb:9a53bc5677ddbcd6ed326262fc81892ecffd000669e8b4c405c365ebca1b83b7@ec2-44-195-100-240.compute-1.amazonaws.com:5432/d1fa89iv1een6c?sslmode=require'));
    final url = databaseUrl.value;
    final uri = Uri.parse(url);
    final connection = PostgreSQLConnection(
      uri.host,
      uri.port,
      uri.pathSegments.first,
      username: uri.userInfo.split(':').first,
      password: uri.userInfo.split(':').last,
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
