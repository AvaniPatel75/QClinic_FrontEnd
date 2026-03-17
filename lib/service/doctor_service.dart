import 'dart:convert';
import 'package:hospital_api_exam/config/api_endpoints.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../model/appointment_model.dart';
import '../model/doctor_model.dart';

class DoctorService {
  final ApiConfig _api = ApiConfig();

  Future<List<DoctorModel>> fetchDoctors() async {
    final http.Response res = await _api.get(doctorQueueEndpoint);
    if (res.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(res.body);
        return data
            .map((json) =>
                DoctorModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        throw Exception('Failed to parse doctors: ${e.toString()}');
      }
    }
    throw Exception('Unable to load doctors. Status: ${res.statusCode}');
  }

  Future<DoctorModel> fetchDoctorById(int id) async {
    final http.Response res = await _api.get('$doctorQueueEndpoint/$id');
    if (res.statusCode == 200) {
      try {
        return DoctorModel.fromJson(
            jsonDecode(res.body) as Map<String, dynamic>);
      } catch (e) {
        throw Exception('Failed to parse doctor: ${e.toString()}');
      }
    }
    throw Exception('Unable to load doctor. Status: ${res.statusCode}');
  }

  Future<List<AppointmentModel>> getTodaysQueue() async {
    final http.Response res = await _api.get(doctorQueueEndpoint);
    if (res.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(res.body);
        return data
            .map((json) =>
                AppointmentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        throw Exception('Failed to parse doctor queue: ${e.toString()}');
      }
    }
    throw Exception(
        'Unable to load doctor queue. Status: ${res.statusCode}');
  }

  Future<List<AppointmentModel>> getAllAppointments() async {
    final http.Response res = await _api.get(doctorQueueEndpoint);
    if (res.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(res.body);
        return data
            .map((json) =>
                AppointmentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        throw Exception('Failed to parse appointments: ${e.toString()}');
      }
    }
    throw Exception(
        'Unable to load appointments. Status: ${res.statusCode}');
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
