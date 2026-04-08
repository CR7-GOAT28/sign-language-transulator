import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import 'home_screen.dart';

class SignLanguageApp extends StatefulWidget {
  final List<CameraDescription> cameras;

  const SignLanguageApp({
    super.key,
    required this.cameras,
  });

  @override
  State<SignLanguageApp> createState() => _SignLanguageAppState();
}

class _SignLanguageAppState extends State<SignLanguageApp> {
  bool _loading = true;
  bool _isLoggedIn = false;
  String _userName = '';
  int _avatarIconIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      _userName = prefs.getString('user_name') ?? '';
      _avatarIconIndex = prefs.getInt('avatar_icon_index') ?? 0;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Sign Language Translator',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      ),
      home: _loading
          ? const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      )
          : _isLoggedIn
          ? HomeScreen(
        cameras: widget.cameras,
        userName: _userName,
        avatarIconIndex: _avatarIconIndex,
      )
          : LoginScreen(cameras: widget.cameras),
    );
  }
}