import 'package:flutter/material.dart';

class IdInfoCard extends StatelessWidget {
  final String name;
  final String nationalId;
  final String address;
  final String birthDate;

  const IdInfoCard({
    super.key,
    required this.name,
    required this.nationalId,
    required this.address,
    required this.birthDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromARGB(255, 118, 226, 136).withOpacity(0.5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 11, 58, 30).withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(Icons.person_rounded, 'Full Name', name),
                const _InfoDivider(),
                _buildInfoRow(Icons.badge_rounded, 'National ID', nationalId),
                const _InfoDivider(),
                _buildInfoRow(Icons.location_on_rounded, 'Address', address),
                const _InfoDivider(),
                _buildInfoRow(Icons.cake_rounded, 'Birth Date', birthDate),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 118, 226, 136).withOpacity(0.3),
            const Color.fromARGB(255, 118, 226, 136).withOpacity(0.1),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 11, 58, 30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.badge_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Verified from National ID',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color.fromARGB(255, 11, 58, 30),
            ),
          ),
          const Spacer(),
          const Icon(Icons.lock_rounded, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color.fromARGB(255, 11, 58, 30).withOpacity(0.6),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                value.isEmpty ? '—' : value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 11, 58, 30),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoDivider extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 16,
      thickness: 0.8,
      color: Colors.grey.withOpacity(0.15),
    );
  }
}
