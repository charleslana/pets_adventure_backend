import 'package:pets_adventure_backend/src/core/service/bcrypt/bcrypt_service.dart';
import 'package:pets_adventure_backend/src/core/service/bcrypt/bcrypt_service_impl.dart';
import 'package:pets_adventure_backend/src/core/service/database/postgres/postgres_database.dart';
import 'package:pets_adventure_backend/src/core/service/database/remote_database.dart';
import 'package:pets_adventure_backend/src/core/service/jwt/dart_jsonwebtoken/jwt_service_impl.dart';
import 'package:pets_adventure_backend/src/core/service/jwt/jwt_service.dart';
import 'package:pets_adventure_backend/src/core/service/request_extractor/request_extractor.dart';
import 'package:shelf_modular/shelf_modular.dart';

class CoreModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<RemoteDatabase>((i) => PostgresDatabase(), export: true),
        Bind.singleton<JwtService>((i) => JwtServiceImpl(), export: true),
        Bind.singleton<BCryptService>((i) => BCryptServiceImpl(), export: true),
        Bind.singleton((i) => RequestExtractor(), export: true),
      ];
}
