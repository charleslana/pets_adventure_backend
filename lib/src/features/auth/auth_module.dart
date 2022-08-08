import 'package:pets_adventure_backend/src/features/auth/data_source/auth_data_source_impl.dart';
import 'package:pets_adventure_backend/src/features/auth/interface/auth_data_source.dart';
import 'package:pets_adventure_backend/src/features/auth/repository/auth_repository.dart';
import 'package:pets_adventure_backend/src/features/auth/resource/auth_resource.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AuthModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<AuthDataSource>((i) => AuthDataSourceImpl(i())),
        Bind.singleton((i) => AuthRepository(i(), i(), i())),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.resource(AuthResource()),
      ];
}
