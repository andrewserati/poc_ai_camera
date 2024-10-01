import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

final class TensorFlowService {
  late final Interpreter interpreter;
  late final Tensor inputTensor;
  late final Tensor outputTensor;
  late final List<String> labels;

  void init() async {
    await _loadTFModel();
  }

  List<double> process({required File image}) {
    img.Image? imageInput = img.decodeImage(image.readAsBytesSync());
    img.Image resizedImage =
        img.copyResize(imageInput!, width: 224, height: 224);

    var input = _imageToByteListFloat32(resizedImage, 224);
    var output = List.filled(1 * 2, 0).reshape([1, 2]);

    interpreter.run(input, output);

    return output.first as List<double>;
  }

  Future<void> _loadTFModel() async {
    interpreter = await Interpreter.fromAsset('assets/model_unquant.tflite',
        options: InterpreterOptions());
  }

  Uint8List _imageToByteListFloat32(img.Image image, int inputSize) {
    var buffer = Float32List(1 * inputSize * inputSize * 3).buffer;
    var byteData = buffer.asByteData();
    int pixelIndex = 0;
    for (int i = 0; i < inputSize; i++) {
      for (int j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        num red = pixel.r;
        num green = pixel.g;
        num blue = pixel.b;
        byteData.setFloat32(
            pixelIndex++ * 4, (red - 127.5) / 127.5, Endian.little);
        byteData.setFloat32(
            pixelIndex++ * 4, (green - 127.5) / 127.5, Endian.little);
        byteData.setFloat32(
            pixelIndex++ * 4, (blue - 127.5) / 127.5, Endian.little);
      }
    }
    return buffer.asUint8List();
  }
}
