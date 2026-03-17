import 'package:flutter/material.dart';
import 'package:hospital_api_exam/service/appointment_service.dart';
import 'package:hospital_api_exam/model/appointment_model.dart';
import 'appointment_detail_screen.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  List<AppointmentModel> _appointments = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final appointments = await _appointmentService.getMyAppointments();
      setState(() {
        _appointments = appointments;
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
        title: const Text('My Appointments'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAppointments,
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
                        onPressed: _loadAppointments,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _appointments.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No appointments found', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          Text('Book your first appointment!', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = _appointments[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getStatusColor(appointment.status ?? ''),
                              child: const Icon(Icons.calendar_today, color: Colors.white),
                            ),
                            title: Text('Appointment #${appointment.id ?? 'N/A'}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date: ${_formatDate(appointment.appointmentDate)}'),
                                Text('Time: ${appointment.timeSlot ?? 'N/A'}'),
                                Text(
                                  'Status: ${appointment.status ?? 'Unknown'}',
                                  style: TextStyle(
                                    color: _getStatusColor(appointment.status ?? ''),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (appointment.queueEntry != null)
                                  Text(
                                    'Queue Token: ${appointment.queueEntry!.tokenNumber ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                              ]
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AppointmentDetailScreen(
                                    appointmentId: (appointment.id ?? 0).toInt(),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
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
