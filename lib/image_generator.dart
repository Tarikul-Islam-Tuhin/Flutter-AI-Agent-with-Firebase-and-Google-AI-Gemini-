import 'dart:typed_data';
import 'package:firebase_ai/firebase_ai.dart';

class AIImageGenerator {
  ImagenModel model = FirebaseAI.googleAI().imagenModel(model: 'gemini-2.0-flash', generationConfig: ImagenGenerationConfig(numberOfImages: 4));

  Future<List<Uint8List>> generateImages(String prompt) async {
    final res = await model.generateImages(prompt);

    final images = res.images.map((ImagenInlineImage e) => e.bytesBase64Encoded).toList();

    return images;
  }
}
