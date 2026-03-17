import 'dart:convert';
import 'package:hospital_api_exam/config/api_endpoints.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../model/appointment_model.dart';

class QueueService {
  final ApiConfig _api = ApiConfig();

  Future<List<QueueEntry>> getDailyQueue(String date) async {
    final http.Response res = await _api.get('$queueEndpoint?date=$date');
    if (res.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(res.body);
        return data
            .map((json) =>
                QueueEntry.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        throw Exception('Failed to parse queue entries: ${e.toString()}');
      }
    }
    throw Exception(
        'Unable to load queue entries. Status: ${res.statusCode}');
  }

  Future<bool> updateQueueStatus({
    required int queueId,
    required String status,
  }) async {
    try {
      final http.Response res = await _api.patch('$queueEndpoint/$queueId', {
        'status': status.replaceAll('_', '-'),
      });

      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
