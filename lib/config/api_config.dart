import 'dart:convert';

import 'package:http/http.dart' as http;
import '../service/preference_service.dart';

class ApiConfig {
  static const String baseUrl = 'https://cmsback.sampaarsh.cloud/';

  final PreferenceService _prefs = PreferenceService();

  Uri _uri(String endpoint) => Uri.parse('$baseUrl$endpoint');

  Future<Map<String, String>> _authHeaders({Map<String, String>? extra}) async {
    final token = await _prefs.getToken();
    return {
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      ...?extra,
    };
  }

  Future<http.Response> get(String endpoint, {bool auth = true}) async {
    return http.get(
      _uri(endpoint),
      headers: auth
          ? await _authHeaders()
          : const {'Content-Type': 'application/json'},
    );
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body,
      {bool auth = true}) async {
    return http.post(
      _uri(endpoint),
      headers: auth
          ? await _authHeaders()
          : const {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  Future<http.Response> patch(String endpoint, Map<String, dynamic> body,
      {bool auth = true}) async {
    return http.patch(
      _uri(endpoint),
      headers: auth
          ? await _authHeaders()
          : const {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String endpoint, {bool auth = true}) async {
    return http.delete(
      _uri(endpoint),
      headers: auth
          ? await _authHeaders()
          : const {'Content-Type': 'application/json'},
    );
  }
}
