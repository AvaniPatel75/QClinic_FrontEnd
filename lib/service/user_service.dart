import 'dart:convert';
import 'package:hospital_api_exam/config/api_endpoints.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../model/clinic_model.dart';
import '../model/user_model.dart';

class UserService {
  final ApiConfig _api = ApiConfig();

  Future<ClinicModel> getClinicInfo() async {
    final http.Response res = await _api.get(adminClinicEndpoint);
    if (res.statusCode == 200) {
      try {
        return ClinicModel.fromJson(
            jsonDecode(res.body) as Map<String, dynamic>);
      } catch (e) {
        throw Exception('Failed to parse clinic info: ${e.toString()}');
      }
    }
    throw Exception('Unable to load clinic info. Status: ${res.statusCode}');
  }

  Future<List<User>> getUsers() async {
    final http.Response res = await _api.get(adminUsersEndpoint);
    if (res.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(res.body);
        return data
            .map((json) => User.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        throw Exception('Failed to parse users: ${e.toString()}');
      }
    }
    throw Exception('Unable to load users. Status: ${res.statusCode}');
  }

  Future<bool> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final http.Response res = await _api.post(adminUsersEndpoint, {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    });
    return _isSuccess(res);
  }

  bool _isSuccess(http.Response res) {
    if (res.statusCode == 200 || res.statusCode == 201) {
      try {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        return json['error'] == false;
      } catch (_) {
        return true;
      }
    }
    return false;
  }
}
