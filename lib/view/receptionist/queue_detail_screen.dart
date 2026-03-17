import 'package:flutter/material.dart';
import 'package:hospital_api_exam/model/appointment_model.dart';
import 'package:hospital_api_exam/service/queue_service.dart';

class QueueDetailScreen extends StatefulWidget {
  final QueueEntry queueEntry;
  final VoidCallback? onStatusUpdated;

  const QueueDetailScreen({
    super.key,
    required this.queueEntry,
    this.onStatusUpdated,
  });

  @override
  State<QueueDetailScreen> createState() => _QueueDetailScreenState();
}

class _QueueDetailScreenState extends State<QueueDetailScreen> {
  final QueueService _queueService = QueueService();
  bool _isUpdating = false;

  late String _currentStatus;
  // Canonical backend status values (underscore, matches API guide)
  final Map<String, List<String>> _validTransitions = {
    'waiting': ['in_progress', 'skipped'],
    'in_progress': ['done', 'skipped'],
    'done': [],
    'skipped': [],
  };
  final Color _brandPrimary = const Color(0xFF2D9CDB); // clinic-blue accent

  @override
  void initState() {
    super.initState();
    _currentStatus = _normalize(widget.queueEntry.status ?? 'waiting');
  }

  Future<void> _updateStatus(String newStatus) async {
    setState(() => _isUpdating = true);

    try {
      final success = await _queueService.updateQueueStatus(
        queueId: (widget.queueEntry.id ?? 0).toInt(),
        status: _toApi(newStatus),
      );

      if (success && mounted) {
        setState(() => _currentStatus = _normalize(newStatus));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to ${newStatus.replaceAll('_', ' ').toUpperCase()}'),
            backgroundColor: Colors.green,
          ),
        );

        widget.onStatusUpdated?.call();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update status. Check console for details.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Queue Entry #${widget.queueEntry.tokenNumber ?? 'N/A'}',
          style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87, letterSpacing: 0.3),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -120,
            right: -80,
            child: _Blob(color: _brandPrimary.withOpacity(0.12), size: 280),
          ),
          Positioned(
            top: 120,
            left: -100,
            child: _Blob(color: _brandPrimary.withOpacity(0.08), size: 240),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroHeader(
                  primary: _brandPrimary,
                  token: widget.queueEntry.tokenNumber?.toString() ?? 'N/A',
                  status: _currentStatus,
                  clinicId: widget.queueEntry.clinicId?.toString() ?? '—',
                ),

                const SizedBox(height: 20),

                const _SectionTitle(icon: Icons.info_outline, title: 'Queue Details'),
                _SectionCard(
                  child: Column(
                    children: [
                      _buildDetailRow('Queue ID', '${widget.queueEntry.id ?? 'N/A'}'),
                      _buildDetailRow('Appointment ID', '${widget.queueEntry.appointmentId ?? 'N/A'}'),
                      _buildDetailRow('Clinic ID', '${widget.queueEntry.clinicId ?? 'N/A'}'),
                      _buildDetailRow('Queue Date', _formatDate(widget.queueEntry.queueDate)),
                      _buildDetailRow('Created', _formatDate(widget.queueEntry.createdAt)),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const _SectionTitle(icon: Icons.swap_horiz, title: 'Update Status'),
                _SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select new status',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _validTransitions.keys.map((status) {
                          final isCurrentStatus = status == _currentStatus;
                          final label = status.replaceAll('_', ' ').toUpperCase();
                          return ChoiceChip(
                            label: Text(
                              label,
                              style: TextStyle(
                                color: isCurrentStatus ? Colors.white : _getStatusColor(status),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            selected: isCurrentStatus,
                            onSelected: (_isUpdating || isCurrentStatus || !_canTransitionTo(status))
                                ? null
                                : (_) => _updateStatus(status),
                            selectedColor: _getStatusColor(status),
                            backgroundColor: _getStatusColor(status).withOpacity(0.12),
                            pressElevation: 0,
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isUpdating || _currentStatus == 'done'
                                  ? null
                                  : (_canTransitionTo('done') ? () => _updateStatus('done') : null),
                              icon: const Icon(Icons.check_rounded),
                              label: const Text('Mark Done'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _brandPrimary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isUpdating || _currentStatus == 'skipped'
                                  ? null
                                  : (_canTransitionTo('skipped') ? () => _updateStatus('skipped') : null),
                              icon: const Icon(Icons.skip_next_rounded, color: Colors.red),
                              label: const Text('Skip'),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red),
                                foregroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (_normalize(status)) {
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

  bool _canTransitionTo(String target) {
    final current = _normalize(_currentStatus);
    final next = _normalize(target);
    return _validTransitions[current]?.contains(next) ?? false;
  }

  String _normalize(String status) => status.replaceAll('-', '_').toLowerCase();
  String _toApi(String status) => _normalize(status);

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  const _SectionCard({required this.child, this.gradient});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(18);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? Colors.white : null,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
        border: gradient == null
            ? Border.all(color: const Color(0xFFE6ECF5))
            : null,
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final Color color;
  final Color background;

  const _StatusChip({
    required this.text,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final Color primary;
  final String token;
  final String status;
  final String clinicId;
  const _HeroHeader({
    required this.primary,
    required this.token,
    required this.status,
    required this.clinicId,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      gradient: LinearGradient(
        colors: [primary, primary.withOpacity(0.9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: Colors.white.withOpacity(0.14),
                child: Icon(Icons.medical_services_rounded, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Token $token',
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'Clinic ID: $clinicId',
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                  ),
                ],
              ),
              const Spacer(),
              _StatusChip(
                text: status.toUpperCase().replaceAll('_', ' '),
                color: primary,
                background: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _infoPill(icon: Icons.timer_outlined, label: 'Queue Date', value: '--'),
              const SizedBox(width: 10),
              _infoPill(icon: Icons.event_available_outlined, label: 'Status', value: status.toUpperCase()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoPill({required IconData icon, required String label, required String value}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12)),
                  Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
