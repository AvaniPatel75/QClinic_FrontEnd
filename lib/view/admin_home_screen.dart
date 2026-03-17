import 'package:flutter/material.dart';
import 'package:hospital_api_exam/view/admin/clinic_info_screen.dart';
import 'package:hospital_api_exam/view/admin/user_list_screen.dart';
import 'package:hospital_api_exam/view/admin/create_user_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF2D9CDB);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Admin Dashboard',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroCard(
              brand: brand,
              title: 'Clinic Control',
              subtitle: 'Manage users and clinic info',
              icon: Icons.dashboard_customize,
            ),
            const SizedBox(height: 14),
            const Text('Manage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            _ActionCard(
              color: brand,
              title: 'Clinic Information',
              subtitle: 'View clinic details & stats',
              icon: Icons.business,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClinicInfoScreen()),
              ),
            ),
            const SizedBox(height: 10),
            _ActionCard(
              color: Colors.teal,
              title: 'Manage Users',
              subtitle: 'Doctors, receptionists, patients',
              icon: Icons.people_alt,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserListScreen()),
              ),
            ),
            const SizedBox(height: 10),
            _ActionCard(
              color: Colors.orange,
              title: 'Create New User',
              subtitle: 'Add staff or patients',
              icon: Icons.person_add,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateUserScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionCard({required this.color, required this.title, required this.subtitle, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final Color brand;
  final String title;
  final String subtitle;
  final IconData icon;
  const _HeroCard({required this.brand, required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [brand, brand.withOpacity(0.85)]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.9))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
