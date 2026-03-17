import 'dart:convert';
import 'package:hospital_api_exam/config/api_endpoints.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../model/report_model.dart';

class ReportService {
  final ApiConfig _api = ApiConfig();

  Future<List<ReportModel>> getMyReports() async {
    final http.Response res = await _api.get('$reportsEndpoint/my');
    if (res.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(res.body);
        return data.map((json) => ReportModel.fromJson(json as Map<String, dynamic>)).toList();
      } catch (e) {
        throw Exception('Failed to parse reports: ${e.toString()}');
      }
    }
    throw Exception('Unable to load reports. Status: ${res.statusCode}');
  }

  /// Add report (Doctor)
  Future<bool> addReport({
    required int appointmentId,
    required String diagnosis,
    String? testRecommended,
    String? remarks,
  }) async {
    final Map<String, dynamic> body = {
      'diagnosis': diagnosis,
      if (testRecommended != null && testRecommended.isNotEmpty)
        'testRecommended': testRecommended,
      if (remarks != null && remarks.isNotEmpty) 'remarks': remarks,
    };

    final http.Response res =
        await _api.post('$reportsEndpoint/$appointmentId', body);

    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    }

    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) {
        final msg = decoded['message'] ?? decoded['error'] ?? 'Failed to add report';
        final field = decoded['field'];
        throw Exception(field != null ? '$msg (field: $field)' : msg.toString());
      }
    } catch (_) {}

    throw Exception('Failed to add report (status ${res.statusCode})');
  }
}
