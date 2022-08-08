import 'package:pets_adventure_backend/src/features/user/data_source/user_data_source_impl.dart';
import 'package:pets_adventure_backend/src/features/user/interface/user_data_source.dart';
import 'package:pets_adventure_backend/src/features/user/repository/user_repository.dart';
import 'package:pets_adventure_backend/src/features/user/resource/user_resource.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UserModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<UserDataSource>((i) => UserDataSourceImpl(i())),
        Bind.singleton((i) => UserRepository(i(), i())),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.resource(UserResource()),
      ];
}
