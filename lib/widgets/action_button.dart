import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              offset: const Offset(0, 8),
              color: Colors.black.withOpacity(0.06),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF7B61FF)),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}
