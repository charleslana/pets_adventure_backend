abstract class JwtService {
  String generateToken(Map<dynamic, dynamic> claims, String audience);
  void verifyToken(String token, String audience);
  Map<dynamic, dynamic> getPayload(String token);
}
