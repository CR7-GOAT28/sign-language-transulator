import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../screens/app.dart';

late final List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(SignLanguageApp(cameras: cameras));
}