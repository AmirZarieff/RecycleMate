import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/scan_record.dart';
import '../services/scan_history_service.dart';
import '../services/google_vision_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String? _detectedLabels;
  String? _selectedMaterial;
  bool _isSaving = false;
  bool _isAnalyzingImage = false;
  File? _capturedImage;
  final TextEditingController _weightController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  static const String _userId = 'demo_user';

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _captureAndAnalyzeImage() async {
    try {
      setState(() => _isAnalyzingImage = true);

      // Capture image from camera
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) {
        setState(() => _isAnalyzingImage = false);
        return;
      }

      // Analyze with Google Vision
      final labels = await GoogleVisionService.analyzeImage(File(image.path));
      final materialType =
          GoogleVisionService.classifyMaterial(labels).toLowerCase();

      setState(() {
        _capturedImage = File(image.path);
        _selectedMaterial = materialType;
        _detectedLabels = labels.take(5).join(', ');
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Detected: ${materialType.toUpperCase()}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAnalyzingImage = false);
      }
    }
  }

  int _calculatePoints(double weightKg) {
    return (weightKg * 10).round();
  }

  String _instructionsForMaterial(String materialType) {
    switch (materialType) {
      case 'plastic':
        return 'Rinse the item and place it in the plastics bin.';
      case 'glass':
        return 'Remove caps and place in the glass recycling bin.';
      case 'paper':
        return 'Ensure it is dry and place in the paper bin.';
      case 'cans':
        return 'Rinse and place in the metal/cans recycling bin.';
      case 'ewaste':
        return 'Bring to an e-waste drop-off point.';
      case 'clothes':
        return 'Donate if reusable, otherwise use textile bins.';
      default:
        return 'Use manual selection or check local guidelines.';
    }
  }

  Future<void> _submitScan(BuildContext context) async {
    final weightKg = double.tryParse(_weightController.text) ?? 0;

    if (_selectedMaterial == null || _selectedMaterial == 'unknown') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture and analyze an item first.'),
        ),
      );
      return;
    }

    if (weightKg <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid weight.')),
      );
      return;
    }

    final materialType = _selectedMaterial!;
    final instructions = _instructionsForMaterial(materialType);
    final points = _calculatePoints(weightKg);

    setState(() => _isSaving = true);

    final record = ScanRecord(
      id: '',
      userId: _userId,
      code: _detectedLabels ?? 'Vision Detection',
      materialType: materialType,
      weightKg: weightKg,
      points: points,
      instructions: instructions,
      createdAt: DateTime.now(),
    );

    try {
      await ScanHistoryService().addRecord(record);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Scan saved successfully.'),
            backgroundColor: Colors.green,
          ),
        );
        // Reset form
        setState(() {
          _capturedImage = null;
          _detectedLabels = null;
          _selectedMaterial = null;
          _weightController.clear();
        });
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Recyclables'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Captured Image Preview
              if (_capturedImage != null)
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Image.file(
                    _capturedImage!,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Card(
                  child: Container(
                    height: 300,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No image captured',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Capture Button
              ElevatedButton.icon(
                onPressed: _isAnalyzingImage ? null : _captureAndAnalyzeImage,
                icon: _isAnalyzingImage
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.camera_alt),
                label: Text(
                  _isAnalyzingImage
                      ? 'Analyzing...'
                      : 'Capture & Analyze with Vision',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),

              // Detection Results
              if (_detectedLabels != null) ...[
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue[700]),
                            const SizedBox(width: 8),
                            Text(
                              'Detection Results',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Material: ${_selectedMaterial?.toUpperCase() ?? "UNKNOWN"}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Detected: $_detectedLabels',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _instructionsForMaterial(_selectedMaterial ?? ''),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Weight Input
              TextField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Weight (KG)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.scale),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _isSaving ? null : () => _submitScan(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: Text(
                  _isSaving ? 'Saving...' : 'Submit Scan',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),

              // History Button
              OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/scan-history'),
                icon: const Icon(Icons.history),
                label: const Text('View Scan History'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
