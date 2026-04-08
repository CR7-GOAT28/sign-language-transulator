import 'package:flutter/material.dart';

class CameraAccessButton extends StatelessWidget {
  final Future<void> Function() onTap;
  const CameraAccessButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              offset: const Offset(0, 8),
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: Row(
          children: const [
            Icon(Icons.camera_alt_rounded, color: Color(0xFF7B61FF)),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Translate from Camera",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}
