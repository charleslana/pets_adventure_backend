// ignore_for_file: one_member_abstracts

abstract class RemoteDatabase {
  Future<List<Map<String, Map<String, dynamic>>>> query(
    String queryText, {
    Map<String, dynamic> variables = const {},
  });
}
