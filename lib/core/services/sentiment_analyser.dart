import 'package:dart_sentiment/dart_sentiment.dart';

class SentimentAnalyzer {
  // SentimentAnalyzer() {
  //   _loadModel();
  // }

  // Interpreter? _interpreter;
  //
  // Future<void> _loadModel() async {
  //   try {
  //     _interpreter = await Interpreter.fromAsset(
  //       'assets/sentiment_model.tflite',
  //     );
  //     debugPrint('TensorFlow Lite model loaded successfully.');
  //   } on Exception catch (e) {
  //     debugPrint('Error loading model: $e');
  //   }
  // }
  //
  // /// Check if interpreter is loaded before inference
  // bool get isModelLoaded => _interpreter != null;
  //
  // /// Pre-process the text input into a fixed-size tensor
  // List<List<String>> _preProcessText(String text) {
  //   // final words = text.toLowerCase().split(' ');
  //   //
  //   // // Define a fixed input size (Ensure it matches model's expected input shape)
  //   // const maxWords = 128;
  //   // List<int> input = List.filled(maxWords, 0);
  //   //
  //   // for (var i = 0; i < words.length && i < input.length; i++) {
  //   //   input[i] = words[i].hashCode;
  //   // }
  //   // return [input];
  //   return [
  //     [text],
  //   ]; // USE Lite expects [[text]] as input
  // }
  //
  // Future<double> analyzeText(String entryContent) async {
  //   // Ensure model is loaded
  //   if (!isModelLoaded) {
  //     debugPrint('Error: Model not yet loaded.');
  //     return List.filled(512, 0.0).reduce((a, b) => a + b); // Return an error indicator
  //   }
  //
  //   final inputTensor = _preProcessText(entryContent);
  //   List<List<double>> outputTensor = [List.filled(512, 0.0)]; // Correct shape
  //
  //   try {
  //     _interpreter!.run(inputTensor, outputTensor);
  //     final embedding = outputTensor[0];
  //
  //     // Convert the 512D vector into a single sentiment score
  //     final score = embedding.reduce((a, b) => a + b) / embedding.length;
  //
  //     // Normalize the score into a 0 to 1 range
  //     final normalizedScore = (score + 20) / 40; // Adjust range
  //
  //     debugPrint('Sentiment analysis score: $normalizedScore');
  //     return normalizedScore.clamp(0.0, 1.0); // Ensure it's between 0 and 1
  //   } on Exception catch (e) {
  //     debugPrint('Error during inference: $e');
  //     return 0.5;
  //   }
  // }

  // String interpretResult(List<double> embedding) {
  //   // Example rule: Sum positive/negative dimensions (not ideal, needs real classifier)
  //   double sum = embedding.reduce((a, b) => a + b);
  //   if (sum > 5.0) return 'Positive';
  //   if (sum < -5.0) return 'Negative';
  //   return 'Neutral';
  // }

  final _sentiment = Sentiment();

  Future<double> analyzeText(String entryContent) async {
    final result = _sentiment.analysis(entryContent, emoji: true);
    final score = result['comparative'] as double? ?? 0.0;
    return score;
  }

  String interpretResult(double score) {
    if (score > 0.1) {
      return 'Positive';
    } else if (score < -0.1) {
      return 'Negative';
    } else {
      return 'Neutral';
    }
  }
}
