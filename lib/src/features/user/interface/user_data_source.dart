abstract class UserDataSource {
  Future<List<Map<String, dynamic>>> findAll();
  Future<Map<String, dynamic>> findByEmail(String email);
  Future<Map<String, dynamic>> findById(int id);
  Future<Map<String, dynamic>> findByName(String name);
  Future<void> deleteById(int id);
  Future<Map<String, dynamic>> save(Map<String, dynamic> data);
  Future<Map<String, dynamic>> updateName(Map<String, dynamic> data);
}
