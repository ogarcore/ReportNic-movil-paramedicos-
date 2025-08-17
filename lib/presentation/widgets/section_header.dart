import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFBBDEFB),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Color(0xFF1565C0), size: 20),
        ),
        const SizedBox(width: 15),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1565C0),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
