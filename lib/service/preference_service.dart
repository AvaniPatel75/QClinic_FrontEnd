
import 'package:shared_preferences/shared_preferences.dart';
class PreferenceService {

  SharedPreferences? _preferences;

  Future<void> initPreferenses() async{
    _preferences??=await SharedPreferences.getInstance();

  }

  Future<void> saveToken(String token) async{
    await initPreferenses();
    await _preferences!.setString('token', token);
  }

  Future<String> getToken()async{
    await  initPreferenses();
    return await _preferences!.getString('token')??"";
  }

  Future<void> clear() async{
    await initPreferenses();
    await _preferences!.clear();
  }

}
