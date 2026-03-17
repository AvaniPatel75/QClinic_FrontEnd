import 'dart:convert';
import 'package:hospital_api_exam/config/api_endpoints.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../model/appointment_model.dart';

class AppointmentService {
  final ApiConfig _api = ApiConfig();

  Future<bool> bookAppointment({
    required String appointmentDate,
    required String timeSlot,
  }) async {
    final http.Response res = await _api.post(appointmentsEndpoint, {
      'appointmentDate': appointmentDate,
      'timeSlot': timeSlot,
    });
    return _isSuccess(res);
  }

  Future<List<AppointmentModel>> getMyAppointments() async {
    final http.Response res = await _api.get(appointmentsMyEndpoint);
    if (res.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(res.body);
        return data
            .map((json) => AppointmentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        throw Exception('Failed to parse appointments: ${e.toString()}');
      }
    }
    throw Exception('Unable to load appointments. Status: ${res.statusCode}');
  }

  Future<AppointmentModel> getAppointmentDetails(int id) async {
    final http.Response res = await _api.get('$appointmentsEndpoint/$id');
    if (res.statusCode == 200) {
      try {
        return AppointmentModel.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      } catch (e) {
        throw Exception('Failed to parse appointment: ${e.toString()}');
      }
    }
    throw Exception('Unable to load appointment. Status: ${res.statusCode}');
  }

  bool _isSuccess(http.Response res) {
    if (res.statusCode == 200 || res.statusCode == 201) {
      try {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        if (json.containsKey('error') && json['error'] == true) {
          return false;
        }
        return true;
      } catch (_) {
        return true;
      }
    }
    return false;
  }
}
