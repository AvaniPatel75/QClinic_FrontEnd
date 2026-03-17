import 'dart:convert';

import 'package:hospital_api_exam/config/api_endpoints.dart';
import 'package:hospital_api_exam/service/preference_service.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../model/AuthResponse.dart';

class AuthService {
  final ApiConfig _api = ApiConfig();
  final PreferenceService _prefs = PreferenceService();

  Future<AuthResponse> login(
      {required String email, required String password}) async {
    
    final http.Response res = await _api.post(authEndpoint, {
      'email': email,
      'password': password,
    }, auth: false);

    if (res.statusCode != 200) {
      throw Exception(_parseError(res.body) ?? 'Login failed');
    }

    final auth = authResponseFromJson(res.body);
    final token = auth.token;
    if (token != null) {
      await _prefs.saveToken(token);
    }
    return auth;
  }

  Future<void> logout() async {
    await _prefs.clear();
  }

  String? _parseError(String body) {
    try {
      final map = jsonDecode(body) as Map<String, dynamic>;
      return map['message']?.toString();
    } catch (_) {
      return null;
    }
  }
}
