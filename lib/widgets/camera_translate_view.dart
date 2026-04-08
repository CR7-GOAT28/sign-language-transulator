import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'action_button.dart';

class CameraTranslateView extends StatelessWidget {
  final CameraController? controller;
  final Future<void>? initCamera;

  final String detectedText;
  final List<String> suggestions;

  const CameraTranslateView({
    super.key,
    required this.controller,
    required this.initCamera,
    required this.detectedText,
    required this.suggestions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10, bottom: 14),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(18),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: (controller == null || initCamera == null)
                  ? const Center(
                child: Text("No camera found", style: TextStyle(color: Colors.white)),
              )
                  : FutureBuilder(
                future: initCamera,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      controller!.value.isInitialized) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        CameraPreview(controller!),

                        Center(
                          child: Container(
                            width: 260,
                            height: 340,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFF7B61FF), width: 3),
                            ),
                          ),
                        ),

                        Positioned(
                          left: 12,
                          top: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.videocam_rounded, color: Colors.white, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  "Camera Preview",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Positioned(
                          left: 12,
                          right: 12,
                          bottom: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Detected: $detectedText",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.graphic_eq_rounded, color: Colors.white70),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ),

        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: const [
              Icon(Icons.lightbulb_rounded, color: Color(0xFF7B61FF)),
              SizedBox(width: 8),
              Text("Suggestions", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ],
          ),
        ),
        const SizedBox(height: 10),

        if (suggestions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: const Text(
              "Show a sign to get suggestions…",
              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black54),
            ),
          )
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: suggestions
                .map(
                  (s) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEAFF),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  s,
                  style: const TextStyle(color: Color(0xFF7B61FF), fontWeight: FontWeight.w800),
                ),
              ),
            )
                .toList(),
          ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: ActionButton(
                icon: Icons.copy_rounded,
                label: "Copy text",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Copied (mock)")),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ActionButton(
                icon: Icons.record_voice_over_rounded,
                label: "Speak",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("TTS coming soon")),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}
