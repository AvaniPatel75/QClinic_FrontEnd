import 'package:flutter/material.dart';
import 'package:hospital_api_exam/service/queue_service.dart';
import 'package:hospital_api_exam/model/appointment_model.dart';
import 'package:hospital_api_exam/view/receptionist/queue_detail_screen.dart';

class QueueListScreen extends StatefulWidget {
  final DateTime date;

  const QueueListScreen({super.key, required this.date});

  @override
  State<QueueListScreen> createState() => _QueueListScreenState();
}

class _QueueListScreenState extends State<QueueListScreen> {
  final QueueService _queueService = QueueService();
  List<QueueEntry> _queueEntries = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadQueue();
  }

  Future<void> _loadQueue() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final dateStr = '${widget.date.year}-${widget.date.month.toString().padLeft(2, '0')}-${widget.date.day.toString().padLeft(2, '0')}';
      final queueEntries = await _queueService.getDailyQueue(dateStr);
      setState(() {
        _queueEntries = queueEntries;
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
    final dateStr = '${widget.date.day}/${widget.date.month}/${widget.date.year}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Queue - $dateStr'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadQueue,
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
                        onPressed: _loadQueue,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _queueEntries.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.queue, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text('No queue entries for $dateStr', style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          const Text('No appointments scheduled for this date', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        // Queue Summary
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.orange.withValues(alpha: 0.1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildSummaryItem('Total', _queueEntries.length, Colors.blue),
                              _buildSummaryItem('Waiting', _queueEntries.where((q) => _isStatus(q.status, 'waiting')).length, Colors.orange),
                              _buildSummaryItem('In Progress', _queueEntries.where((q) => _isStatus(q.status, 'in_progress')).length, Colors.green),
                              _buildSummaryItem('Done', _queueEntries.where((q) => _isStatus(q.status, 'done')).length, Colors.grey),
                            ],
                          ),
                        ),

                        // Queue List
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _queueEntries.length,
                            itemBuilder: (context, index) {
                              final queueEntry = _queueEntries[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: _getStatusColor(queueEntry.status ?? ''),
                                    child: Text(
                                      '${queueEntry.tokenNumber ?? index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text('Token #${queueEntry.tokenNumber ?? 'N/A'}'),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Appointment ID: ${queueEntry.appointmentId ?? 'N/A'}'),
                                      Text(
                                        'Status: ${queueEntry.status ?? 'Unknown'}',
                                        style: TextStyle(
                                          color: _getStatusColor(queueEntry.status ?? ''),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QueueDetailScreen(
                                          queueEntry: queueEntry,
                                          onStatusUpdated: _loadQueue,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
    );
  }

  Widget _buildSummaryItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (_normalize(status)) {
      case 'waiting':
        return Colors.orange;
      case 'in_progress':
        return Colors.green;
      case 'done':
        return Colors.grey;
      case 'skipped':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  bool _isStatus(String? value, String expected) =>
      _normalize(value ?? '') == _normalize(expected);

  String _normalize(String status) => status.replaceAll('-', '_').toLowerCase();
}
