import 'package:flutter/material.dart';
import 'package:hospital_api_exam/service/appointment_service.dart';
import 'package:hospital_api_exam/model/appointment_model.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final int appointmentId;

  const AppointmentDetailScreen({super.key, required this.appointmentId});

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  AppointmentModel? _appointment;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAppointmentDetails();
  }

  Future<void> _loadAppointmentDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final appointment = await _appointmentService.getAppointmentDetails(widget.appointmentId);
      setState(() {
        _appointment = appointment;
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
        title: const Text('Appointment Details'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAppointmentDetails,
          ),
        ],
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
                        onPressed: _loadAppointmentDetails,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _appointment == null
                  ? const Center(child: Text('Appointment not found'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Appointment Header
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, color: Colors.green),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Appointment #${_appointment!.id ?? 'N/A'}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _buildInfoRow('Date', _formatDate(_appointment!.appointmentDate)),
                                  _buildInfoRow('Time Slot', _appointment!.timeSlot ?? 'N/A'),
                                  _buildInfoRow('Status', _appointment!.status ?? 'Unknown',
                                      color: _getStatusColor(_appointment!.status ?? '')),
                                  if (_appointment!.queueEntry != null) ...[
                                    const SizedBox(height: 8),
                                    const Divider(),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Queue Information',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInfoRow('Token Number', '${_appointment!.queueEntry!.tokenNumber ?? 'N/A'}'),
                                    _buildInfoRow('Queue Status', _appointment!.queueEntry!.status ?? 'Unknown',
                                        color: _getQueueStatusColor(_appointment!.queueEntry!.status ?? '')),
                                  ],
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          if (_appointment!.prescription != null) ...[
                            const Text(
                              'Prescription',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoRow('Medicines', _appointment!.prescription!.medicines ?? 'N/A'),
                                    _buildInfoRow('Dosage', _appointment!.prescription!.dosage ?? 'N/A'),
                                    _buildInfoRow('Duration', _appointment!.prescription!.duration ?? 'N/A'),
                                    if (_appointment!.prescription!.notes != null && _appointment!.prescription!.notes!.isNotEmpty)
                                      _buildInfoRow('Notes', _appointment!.prescription!.notes!),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          if (_appointment!.report != null) ...[
                            const Text(
                              'Medical Report',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoRow('Diagnosis', _appointment!.report!.diagnosis ?? 'N/A'),
                                    _buildInfoRow('Test Recommended', _appointment!.report!.testRecommended ?? 'N/A'),
                                    _buildInfoRow('Remarks', _appointment!.report!.remarks ?? 'N/A'),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          if (_appointment!.prescription == null && _appointment!.report == null) ...[
                            const SizedBox(height: 20),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    const Icon(Icons.medical_services, size: 48, color: Colors.grey),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Medical records not available yet',
                                      style: TextStyle(fontSize: 16, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _appointment!.status == 'completed'
                                          ? 'Your doctor will add prescription and report details soon.'
                                          : 'Medical records will be available after your appointment is completed.',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: color != null ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'queued':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getQueueStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'waiting':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'done':
        return Colors.green;
      case 'skipped':
        return Colors.red;
      default:
        return Colors.grey;
    }
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
