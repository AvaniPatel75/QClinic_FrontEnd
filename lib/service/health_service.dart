import 'dart:convert';
import 'package:hospital_api_exam/config/api_endpoints.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class HealthService {
  final ApiConfig _api = ApiConfig();

  Future<bool> checkHealth() async {
    try {
      final http.Response res = await _api.get(healthEndpoint, auth: false);
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getHealthStatus() async {
    try {
      final http.Response res = await _api.get(healthEndpoint, auth: false);
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

