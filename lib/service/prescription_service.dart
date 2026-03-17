import 'dart:convert';
import 'package:hospital_api_exam/config/api_endpoints.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../model/appointment_model.dart';

class PrescriptionService {
  final ApiConfig _api = ApiConfig();

  /// Get my prescriptions (Patient)
  Future<List<Prescription>> getMyPrescriptions() async {
    final http.Response res = await _api.get(prescriptionsMyEndpoint);
    if (res.statusCode == 200) {
      try {
        final decoded = jsonDecode(res.body);
        List<dynamic> data;
        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map<String, dynamic>) {
          final inner = decoded['data'] ?? decoded['prescriptions'] ?? decoded['items'];
          if (inner is List) {
            data = inner;
          } else {
            data = [];
          }
        } else {
          throw Exception('Unexpected response format');
        }
        return data.map((json) => Prescription.fromJson(json as Map<String, dynamic>)).toList();
      } catch (e) {
        throw Exception('Failed to parse prescriptions: ${e.toString()}');
      }
    }
    throw Exception('Unable to load prescriptions. Status: ${res.statusCode}');
  }

  /// Add prescription (Doctor)
  Future<bool> addPrescription({
    required int appointmentId,
    required String medicines,
    required String dosage,
    required String duration,
    String? notes,
  }) async {
    final Map<String, dynamic> body = {
      'medicines': [
        {
          'name': medicines,
          'dosage': dosage,
          'duration': duration,
        }
      ],
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };

    final http.Response res =
        await _api.post('$prescriptionsEndpoint/$appointmentId', body);

    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    }

    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) {
        final msg = decoded['message'] ?? decoded['error'] ?? 'Failed to add prescription';
        throw Exception(msg.toString());
      }
    } catch (_) {}
    throw Exception('Failed to add prescription (status ${res.statusCode})');
  }
}
