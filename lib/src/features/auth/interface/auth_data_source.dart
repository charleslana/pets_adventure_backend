abstract class AuthDataSource {
  Future<Map<dynamic, dynamic>> getIdAndRoleByEmail(String email);
  Future<String> getRoleById(dynamic id);
  Future<String> getPasswordById(dynamic id);
  Future<void> updatePasswordById(dynamic id, String password);
}
