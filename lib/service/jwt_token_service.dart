import 'package:hospital_api_exam/service/preference_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
class JwtTokenServices {

  Future<Map<String, dynamic>?> getTokenData() async {
    final token = await PreferenceService().getToken();
    if (token.isEmpty || JwtDecoder.isExpired(token)) return null;
    return JwtDecoder.decode(token);
  }

  Future<String?> role() async {
    final data = await getTokenData();
    return data?['data']?['UserRole'] as String?;
  }

  Future<bool?> isDoctor() async {
    final r = await role();
    return r == null ? null : r == 'manager';
  }
  Future<bool?> isPatient() async {
    final r = await role();
    return r == null ? null : r == 'patient';
  }
  Future<bool?> isReceptionist() async {
    final r = await role();
    return r == null ? null : r == 'receptionist';
  }
  Future<bool?> isAdmin() async{
    final r = await role();
    return r == null ? null : r == 'admin';
  }
}
