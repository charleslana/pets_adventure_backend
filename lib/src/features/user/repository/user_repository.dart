// ignore_for_file: sort_constructors_first

import 'package:pets_adventure_backend/src/core/exception/global_exception.dart';
import 'package:pets_adventure_backend/src/core/service/bcrypt/bcrypt_service.dart';
import 'package:pets_adventure_backend/src/features/user/data_source/user_data_source_impl.dart';
import 'package:pets_adventure_backend/src/features/user/interface/user_data_source.dart';
import 'package:pets_adventure_backend/src/features/user/model/dto/user_basic_dto.dart';
import 'package:pets_adventure_backend/src/features/user/model/dto/user_dto.dart';
import 'package:pets_adventure_backend/src/features/user/model/user_model.dart';
import 'package:pets_adventure_backend/src/utils/functions_utils.dart';
import 'package:shelf_modular/shelf_modular.dart';
import 'package:validators/validators.dart' as validator;

class UserRepository {
  final UserDataSource userDataSource;
  final BCryptService bcrypt;

  UserRepository(this.userDataSource, this.bcrypt);

  Future<String> create(ModularArguments arguments) async {
    UserDto dto = UserDto.fromMap(arguments.data);
    _validateFieldsCreateUser(dto);
    final result = await userDataSource.findByEmail(dto.email!);
    if (result.isNotEmpty) {
      throw GlobalException(400, 'E-mail já existe');
    }
    dto = dto.copyWith(password: bcrypt.generateHash(dto.password!.trim()));
    await userDataSource.save(dto.toMap());
    return 'Usuário criado com sucesso';
  }

  Future<String> delete(ModularArguments arguments) async {
    final id = int.tryParse(arguments.params['id']) ?? 0;
    final result = await userDataSource.findById(id);
    if (result.isEmpty) {
      throw GlobalException(404, 'Usuário não encontrado');
    }
    await userDataSource.deleteById(id);
    return 'Usuário deletado com sucesso';
  }

  Future<UserModel> get(ModularArguments arguments) async {
    final id = int.tryParse(arguments.params['id']) ?? 0;
    final result = await userDataSource.findById(id);
    if (result.isEmpty) {
      throw GlobalException(404, 'Usuário não encontrado');
    }
    result.remove('password');
    final UserModel user = UserModel.fromMap(result);
    return user;
  }

  Future<List<UserModel>> getAll(Injector<dynamic> injector) async {
    final userRepository = injector.get<UserDataSourceImpl>();
    final result = await userRepository.findAll();
    result.map((element) => element.remove('password')).toList();
    final List<UserModel> users = result.map(UserModel.fromMap).toList();
    return users;
  }

  Future<UserBasicDto> getDetails(int id) async {
    final result = await userDataSource.findById(id);
    if (result.isEmpty) {
      throw GlobalException(404, 'Usuário não encontrado');
    }
    final UserBasicDto user = UserBasicDto.fromMap(result);
    return user;
  }

  Future<String> updateName(ModularArguments arguments) async {
    UserDto dto = UserDto.fromMap(arguments.data);
    _validateFieldsUpdateName(dto);
    final existsUser = await userDataSource.findById(dto.id!);
    if (existsUser.isEmpty) {
      throw GlobalException(404, 'Usuário não encontrado');
    }
    final existsUserName = await userDataSource.findByName(dto.name!);
    _validateNameAlreadyExists(existsUserName, dto);
    dto = dto.copyWith(name: dto.name!.trim());
    await userDataSource.updateName(dto.toMap());
    return 'Usuário atualizado com sucesso';
  }

  void _validateFieldsCreateUser(UserDto dto) {
    if (validator.isNull(dto.email) || validator.isNull(dto.password)) {
      throw GlobalException(400, 'Há campos sem preenchimento');
    }
    if (!validator.isEmail(dto.email!)) {
      throw GlobalException(400, 'E-mail inválido');
    }
    if (!validator.isLength(dto.password!, 6)) {
      throw GlobalException(400, 'A senha deve conter no mínimo 6 caracteres');
    }
  }

  void _validateFieldsUpdateName(UserDto dto) {
    if (validator.isNull(dto.name) || validator.isNull(dto.id.toString())) {
      throw GlobalException(400, 'Há campos sem preenchimento');
    }
    if (!validator.isLength(dto.name!.trim(), 3, 20)) {
      throw GlobalException(400, 'O nome deve conter entre 3 a 20 caracteres');
    }
    if (!validateName(dto.name!)) {
      throw GlobalException(
          400, 'O nome deve conter apenas caracteres alfanumérico');
    }
  }

  void _validateNameAlreadyExists(
      Map<String, dynamic> existsUserName, UserDto dto) {
    if (existsUserName.isNotEmpty) {
      final UserBasicDto user = UserBasicDto.fromMap(existsUserName);
      if (user.name == dto.name && user.id != dto.id) {
        throw GlobalException(400, 'Nome já existe');
      }
    }
  }
}
