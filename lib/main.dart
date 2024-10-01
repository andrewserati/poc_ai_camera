import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:poc_ai_camera/app.dart';
import 'package:poc_ai_camera/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InjectionContainer.register();
  List<CameraDescription> cameras = await availableCameras();
  runApp(AppWidget(cameras));
}
