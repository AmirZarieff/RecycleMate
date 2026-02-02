import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GoogleVisionService {
  static const String _apiKey =
      String.fromEnvironment('GOOGLE_VISION_API_KEY');

  static String get _apiUrl {
    if (_apiKey.isEmpty) {
      throw Exception(
        'GOOGLE_VISION_API_KEY is not set. Pass it via --dart-define.',
      );
    }
    return 'https://vision.googleapis.com/v1/images:annotate?key=$_apiKey';
  }

  /// Analyze an image file and return detected labels
  static Future<List<String>> analyzeImage(File imageFile) async {
    try {
      // Read image and convert to base64
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Prepare request body
      final requestBody = {
        'requests': [
          {
            'image': {'content': base64Image},
            'features': [
              {'type': 'LABEL_DETECTION', 'maxResults': 10}
            ]
          }
        ]
      };

      // Make API request
      final response = await http
          .post(
            Uri.parse(_apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Vision API request timed out'),
          );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Extract labels from response
        final annotations =
            jsonResponse['responses'][0]['labelAnnotations'] ?? [];
        final List<String> labels = [];

        for (var annotation in annotations) {
          labels.add((annotation['description'] as String).toLowerCase());
        }

        return labels;
      } else {
        throw Exception('Vision API error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to analyze image: $e');
    }
  }

  /// Classify materials based on detected labels
  static String classifyMaterial(List<String> labels) {
    if (labels.isEmpty) return 'UNKNOWN';

    // Check for plastic materials
    if (_containsAny(labels, [
      'plastic',
      'bottle',
      'plastic bottle',
      'plastic bag',
      'plastic container'
    ])) {
      return 'PLASTIC';
    }

    // Check for glass
    if (_containsAny(labels, ['glass', 'glass bottle', 'drinking glass'])) {
      return 'GLASS';
    }

    // Check for paper/cardboard
    if (_containsAny(labels, ['paper', 'cardboard', 'box', 'carton'])) {
      return 'PAPER';
    }

    // Check for metal/cans
    if (_containsAny(labels, ['can', 'aluminum', 'metal', 'tin', 'aluminium'])) {
      return 'CANS';
    }

    // Check for electronics/e-waste
    if (_containsAny(labels, [
      'electronic',
      'phone',
      'computer',
      'laptop',
      'keyboard',
      'mouse',
      'charger',
      'cable'
    ])) {
      return 'EWASTE';
    }

    // Check for textiles/clothes
    if (_containsAny(labels, [
      'clothing',
      'cloth',
      'fabric',
      'textile',
      'shirt',
      'pants'
    ])) {
      return 'CLOTHES';
    }

    return 'UNKNOWN';
  }

  static bool _containsAny(List<String> labels, List<String> keywords) {
    for (var label in labels) {
      for (var keyword in keywords) {
        if (label.contains(keyword)) {
          return true;
        }
      }
    }
    return false;
  }
}
