import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const LoginScreen({super.key, required this.cameras});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameCtrl = TextEditingController();
  int _selectedIconIndex = 0;

  final List<IconData> _funkyIcons = const [
    Icons.face_retouching_natural,
    Icons.sentiment_very_satisfied_rounded,
    Icons.emoji_emotions_rounded,
    Icons.local_fire_department_rounded,
    Icons.flash_on_rounded,
    Icons.auto_awesome_rounded,
    Icons.star_rounded,
    Icons.sports_esports_rounded,
  ];

  Future<void> _continue() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your name")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setInt('avatar_icon_index', _selectedIconIndex);
    await prefs.setBool('is_logged_in', true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          cameras: widget.cameras,
          userName: name,
          avatarIconIndex: _selectedIconIndex,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                "Welcome",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              const Text(
                "Enter your name and choose your profile icon",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _nameCtrl,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: "Your name",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Choose your DP",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(_funkyIcons.length, (i) {
                  final selected = i == _selectedIconIndex;
                  return InkWell(
                    onTap: () => setState(() => _selectedIconIndex = i),
                    borderRadius: BorderRadius.circular(18),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFF7B61FF) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                            color: Colors.black.withOpacity(0.06),
                          )
                        ],
                      ),
                      child: Icon(
                        _funkyIcons[i],
                        size: 26,
                        color: selected ? Colors.white : const Color(0xFF7B61FF),
                      ),
                    ),
                  );
                }),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B61FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}