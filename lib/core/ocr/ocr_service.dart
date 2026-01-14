import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'ocr_parser.dart';

class OcrService {
  OcrService();

  Future<OcrResult> recognize(List<File> images) async {
    if (images.isEmpty) {
      return const OcrResult();
    }
    return _recognizeLocal(images);
  }

  Future<OcrResult> _recognizeLocal(List<File> images) async {
    final recognizer = TextRecognizer();
    final buffer = StringBuffer();
    final prepared = <_PreparedImage>[];
    try {
      for (final image in images) {
        final preparedImage = await _prepareForOcr(image);
        prepared.add(preparedImage);
        final inputImage = InputImage.fromFile(preparedImage.file);
        final result = await recognizer.processImage(inputImage);
        buffer.writeln(result.text);
      }
    } finally {
      await recognizer.close();
      for (final item in prepared) {
        if (item.shouldDelete) {
          try {
            await item.file.delete();
          } catch (_) {}
        }
      }
    }

    return OcrParser.parse(buffer.toString());
  }

  Future<_PreparedImage> _prepareForOcr(File input) async {
    final bytes = await input.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      return _PreparedImage(file: input, shouldDelete: false);
    }

    var image = decoded;
    const maxWidth = 1600;
    if (image.width > maxWidth) {
      image = img.copyResize(image, width: maxWidth);
    }
    image = img.grayscale(image);
    image = img.contrast(image, contrast: 120);

    final tempDir = await getTemporaryDirectory();
    final output = File(
      p.join(
        tempDir.path,
        'ocr_${DateTime.now().microsecondsSinceEpoch}.jpg',
      ),
    );
    await output.writeAsBytes(img.encodeJpg(image, quality: 85), flush: true);
    return _PreparedImage(file: output, shouldDelete: true);
  }
}

class _PreparedImage {
  _PreparedImage({required this.file, required this.shouldDelete});

  final File file;
  final bool shouldDelete;
}
