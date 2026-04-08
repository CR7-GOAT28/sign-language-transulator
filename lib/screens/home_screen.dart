import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'history_screen.dart';
import 'login_screen.dart';
import 'translator_screen.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "AI Sign Language Translator",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF7C62FF),
                      Color(0xFF5C49E8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C62FF).withOpacity(0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withOpacity(0.16),
                      child: Icon(
                        icon,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, $userName",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Ready to translate sign language in real time",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              _actionCard(
                icon: Icons.play_circle_fill_rounded,
                title: "Start Translating",
                subtitle: "Open live sign translator",
                bgColor: const Color(0xFF7B61FF),
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

              _actionCard(
                icon: Icons.history_rounded,
                title: "View History",
                subtitle: "See your saved translations",
                bgColor: const Color(0xFF08B26B),
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

              _actionCard(
                icon: Icons.logout_rounded,
                title: "Logout",
                subtitle: "Remove saved profile and sign in again",
                bgColor: const Color(0xFF2E2E36),
                onTap: () => _logout(context),
              ),

              const Spacer(),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE8E9F0)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.tips_and_updates_rounded,
                      color: Color(0xFF7B61FF),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Tip: keep your hand centered and steady for quicker results.",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: bgColor.withOpacity(0.18),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}