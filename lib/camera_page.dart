import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:poc_ai_camera/injection_container.dart';
import 'package:poc_ai_camera/taked_photo_page.dart';
import 'package:poc_ai_camera/tensor_flow_service.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraPage(this.cameras, {super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final TensorFlowService tensorFlowService = getIt<TensorFlowService>();

  late CameraController cameraController;
  File? takedPhoto;

  @override
  void initState() {
    CameraDescription backCamera = widget.cameras
        .where((camera) => camera.lensDirection == CameraLensDirection.back)
        .first;
    cameraController = CameraController(backCamera, ResolutionPreset.max);
    cameraController.initialize().then((_) {
      if (!mounted) return;
      tensorFlowService.init();
      setState(() {});
    });
    super.initState();
  }

  Future<void> _takePicture() async {
    XFile xFile = await cameraController.takePicture();
    takedPhoto = File(xFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CameraPreview(cameraController),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _takePicture().then((_) {
            if (!context.mounted) return;
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return TakedPhotoPage(takedPhoto!);
            }));
          });
        },
        child: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
