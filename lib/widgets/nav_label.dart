import 'package:flutter/material.dart';

class NavLabel extends StatelessWidget {
  const NavLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: const [
          Icon(Icons.auto_awesome, color: Colors.white, size: 18),
          SizedBox(width: 8),
          Text(
            "SmartAI",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
