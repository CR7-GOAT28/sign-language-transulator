import 'package:flutter/material.dart';

class ChipWidget extends StatelessWidget {
  final String text;
  const ChipWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEAFF),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF7B61FF),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
