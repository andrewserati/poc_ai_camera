import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:poc_ai_camera/camera_page.dart';

final class AppWidget extends StatelessWidget {
  final List<CameraDescription> cameras;

  const AppWidget(this.cameras, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraPage(cameras),
    );
  }
}
