import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import 'translator_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<CameraDescription> cameras;
  final String userName;
  final int avatarIconIndex;

  const HomeScreen({
    super.key,
    required this.cameras,
    required this.userName,
    required this.avatarIconIndex,
  });

  static const List<IconData> funkyIcons = [
    Icons.face_retouching_natural,
    Icons.sentiment_very_satisfied_rounded,
    Icons.emoji_emotions_rounded,
    Icons.local_fire_department_rounded,
    Icons.flash_on_rounded,
    Icons.auto_awesome_rounded,
    Icons.star_rounded,
    Icons.sports_esports_rounded,
  ];

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.remove('avatar_icon_index');
    await prefs.remove('is_logged_in');

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(cameras: cameras),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final icon = funkyIcons[
    avatarIconIndex.clamp(0, funkyIcons.length - 1)];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'AI Sign Language Translator',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 17,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C62FF), Color(0xFF5E49E7)],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white.withOpacity(0.18),
                    child: Icon(icon, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Hi, $userName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _homeButton(
              icon: Icons.play_circle_fill_rounded,
              text: "Start Translating",
              color: const Color(0xFF7B61FF),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TranslatorScreen(
                      cameras: cameras,
                      userName: userName,
                      avatarIconIndex: avatarIconIndex,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _homeButton(
              icon: Icons.history_rounded,
              text: "View History",
              color: const Color(0xFF00A86B),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HistoryScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _homeButton(
              icon: Icons.logout_rounded,
              text: "Logout",
              color: const Color(0xFF2F2F35),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}