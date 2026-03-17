import 'package:flutter/material.dart';
import 'package:hospital_api_exam/model/clinic_model.dart';
import 'package:hospital_api_exam/service/user_service.dart';

class ClinicInfoScreen extends StatefulWidget {
  const ClinicInfoScreen({super.key});

  @override
  State<ClinicInfoScreen> createState() => _ClinicInfoScreenState();
}

class _ClinicInfoScreenState extends State<ClinicInfoScreen> {
  final UserService _userService = UserService();
  ClinicModel? _clinicInfo;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadClinicInfo();
  }

  Future<void> _loadClinicInfo() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final clinicInfo = await _userService.getClinicInfo();
      setState(() {
        _clinicInfo = clinicInfo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinic Information'),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: $_error', textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadClinicInfo,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _clinicInfo == null
                  ? const Center(child: Text('No clinic information available'))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _clinicInfo!.name ?? 'Unknown Clinic',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Code: ${_clinicInfo!.code ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Created: ${_formatDate(_clinicInfo!.createdAt)}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Statistics',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.people,
                                          size: 32,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${_clinicInfo!.userCount ?? 0}',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text('Users'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 32,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${_clinicInfo!.appointmentCount ?? 0}',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text('Appointments'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.queue,
                                          size: 32,
                                          color: Colors.orange,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${_clinicInfo!.queueCount ?? 0}',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text('Queue'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
