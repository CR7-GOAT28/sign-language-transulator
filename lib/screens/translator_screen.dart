import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'history_screen.dart';

class TranslatorScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String userName;
  final int avatarIconIndex;

  const TranslatorScreen({
    super.key,
    required this.cameras,
    required this.userName,
    required this.avatarIconIndex,
  });

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  CameraController? _cameraController;
  Timer? _predictionTimer;
  final FlutterTts _flutterTts = FlutterTts();

  bool _isCameraReady = false;
  bool _isTranslating = false;
  bool _isSendingFrame = false;
  bool _isSpeaking = false;

  List<String> _sentence = [];

  static const String _baseUrl = 'http://10.13.198.52:5000';

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

  @override
  void initState() {
    super.initState();
    _setupTts();
    _initializeCamera();
  }

  Future<void> _setupTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.45);

    _flutterTts.setStartHandler(() {
      if (mounted) setState(() => _isSpeaking = true);
    });

    _flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });

    _flutterTts.setCancelHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });

    _flutterTts.setErrorHandler((_) {
      if (mounted) setState(() => _isSpeaking = false);
    });
  }

  Future<void> _initializeCamera() async {
    try {
      if (widget.cameras.isEmpty) return;

      _cameraController = CameraController(
        widget.cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (!mounted) return;
      setState(() {
        _isCameraReady = true;
      });
    } catch (e) {
      debugPrint("Camera init error: $e");
    }
  }

  Future<void> _saveToHistory() async {
    final text = _sentence.join(" ").trim();
    if (text.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final oldHistory = prefs.getStringList('translation_history') ?? [];

    if (oldHistory.isEmpty || oldHistory.last != text) {
      oldHistory.add(text);
      await prefs.setStringList('translation_history', oldHistory);
    }
  }

  Future<void> _startTranslating() async {
    if (!_isCameraReady || _cameraController == null) return;

    setState(() {
      _isTranslating = true;
    });

    _predictionTimer?.cancel();
    _predictionTimer = Timer.periodic(
      const Duration(milliseconds: 300),
          (_) => _captureAndPredict(),
    );
  }

  Future<void> _stopTranslating() async {
    _predictionTimer?.cancel();
    await _saveToHistory();

    if (!mounted) return;
    setState(() {
      _isTranslating = false;
    });
  }

  Future<void> _captureAndPredict() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isSendingFrame ||
        !_isTranslating) {
      return;
    }

    try {
      _isSendingFrame = true;

      final XFile imageFile = await _cameraController!.takePicture();
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse("$_baseUrl/predict"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image": base64Image}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (!mounted) return;

        setState(() {
          final dynamic sentenceData = data["sentence"];
          if (sentenceData is List) {
            _sentence = sentenceData.map((e) => e.toString()).toList();
          }
        });
      } else {
        debugPrint("Backend error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Prediction error: $e");
    } finally {
      _isSendingFrame = false;
    }
  }

  Future<void> _clearAll() async {
    _predictionTimer?.cancel();

    try {
      await http.post(Uri.parse("$_baseUrl/clear"));
    } catch (_) {}

    if (!mounted) return;

    setState(() {
      _isTranslating = false;
      _sentence = [];
    });
  }

  Future<void> _speakSentence() async {
    final sentenceText = _sentence.join(" ").trim();

    if (sentenceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No sentence available to speak")),
      );
      return;
    }

    await _flutterTts.stop();
    await _flutterTts.speak(sentenceText);
  }

  Future<void> _stopSpeaking() async {
    await _flutterTts.stop();
    if (mounted) setState(() => _isSpeaking = false);
  }

  @override
  void dispose() {
    _predictionTimer?.cancel();
    _flutterTts.stop();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icon = _funkyIcons[
    widget.avatarIconIndex.clamp(0, _funkyIcons.length - 1)];
    final sentenceText = _sentence.isEmpty ? "--" : _sentence.join(" ");

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Column(
            children: [
              _buildCompactHeader(icon),
              const SizedBox(height: 8),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 9,
                      child: _buildCameraCard(),
                    ),
                    const SizedBox(height: 8),
                    _buildSentenceCard(sentenceText),
                    const SizedBox(height: 8),
                    _buildButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactHeader(IconData icon) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreen(
                  cameras: widget.cameras,
                  userName: widget.userName,
                  avatarIconIndex: widget.avatarIconIndex,
                ),
              ),
            );
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF7B61FF),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, ${widget.userName}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 1),
              const Text(
                "AI Sign Language Translator",
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HistoryScreen(),
              ),
            );
          },
          icon: const Icon(Icons.history_rounded),
        ),
      ],
    );
  }

  Widget _buildCameraCard() {
    if (!_isCameraReady || _cameraController == null) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    final size = _cameraController!.value.previewSize;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: size == null
                ? CameraPreview(_cameraController!)
                : FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: size.height,
                height: size.width,
                child: CameraPreview(_cameraController!),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: _isTranslating ? Colors.red : Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    _isTranslating ? "LIVE" : "READY",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentenceCard(String sentenceText) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.notes_rounded, color: Color(0xFF7B61FF), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sentence Output",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  sentenceText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF202124),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _smallButton(
                text: "Start",
                icon: Icons.play_arrow_rounded,
                bgColor: const Color(0xFF7B61FF),
                fgColor: Colors.white,
                onPressed: _isTranslating ? null : _startTranslating,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _smallButton(
                text: "Stop",
                icon: Icons.pause_rounded,
                bgColor: const Color(0xFF2D2D32),
                fgColor: Colors.white,
                onPressed: _isTranslating ? _stopTranslating : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _smallOutlineButton(
                text: "Clear",
                icon: Icons.cleaning_services_rounded,
                onPressed: _clearAll,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _smallButton(
                text: _isSpeaking ? "Stop" : "Speak",
                icon: _isSpeaking
                    ? Icons.stop_circle_rounded
                    : Icons.volume_up_rounded,
                bgColor: const Color(0xFF08B26B),
                fgColor: Colors.white,
                onPressed: _isSpeaking ? _stopSpeaking : _speakSentence,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _smallButton({
    required String text,
    required IconData icon,
    required Color bgColor,
    required Color fgColor,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: 42,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 17),
        label: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _smallOutlineButton({
    required String text,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: 42,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 17),
        label: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF7B61FF),
          side: const BorderSide(color: Color(0xFF7B61FF), width: 1.3),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}