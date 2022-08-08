import 'package:pets_adventure_backend/src/core/core_module.dart';
import 'package:pets_adventure_backend/src/features/auth/auth_module.dart';
import 'package:pets_adventure_backend/src/features/swagger/swagger_handler.dart';
import 'package:pets_adventure_backend/src/features/user/user_module.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.get('/', (Request request) => Response.ok('init')),
        Route.get(
            '/**', (Request request) => Response.ok('Rota não encontrada')),
        Route.get('/documentation/**', swaggerHandler),
        Route.module('/', module: UserModule()),
        Route.module('/auth', module: AuthModule()),
      ];
}
