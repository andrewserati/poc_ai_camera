import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poc_ai_camera/injection_container.dart';
import 'package:poc_ai_camera/tensor_flow_service.dart';

class TakedPhotoPage extends StatelessWidget {
  final TensorFlowService tensorFlowService = getIt<TensorFlowService>();

  final File takedPhoto;

  TakedPhotoPage(this.takedPhoto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: Image.file(takedPhoto),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          List<double> result = tensorFlowService.process(image: takedPhoto);
          if (result[0] > result[1]) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('É um(a) gatinho(a)!'),
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Não é um(a) gatinho(a)!'),
            ));
          }
        },
        label: Text('Processar imagem'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
