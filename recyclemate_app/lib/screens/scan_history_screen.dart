import 'package:flutter/material.dart';
import '../models/scan_record.dart';
import '../services/scan_history_service.dart';

class ScanHistoryScreen extends StatelessWidget {
  const ScanHistoryScreen({super.key});

  static const String userId = 'demo_user';

  int _calculatePoints(double weightKg) {
    return (weightKg * 10).round();
  }

  Future<void> _showEditDialog(
    BuildContext context,
    ScanRecord record,
    ScanHistoryService service,
  ) async {
    final weightController =
        TextEditingController(text: record.weightKg.toStringAsFixed(2));
    String materialType = record.materialType;

    final updated = await showDialog<ScanRecord>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Scan Record'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Weight (KG)',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: materialType,
              decoration: const InputDecoration(labelText: 'Material Type'),
              items: const [
                DropdownMenuItem(value: 'plastic', child: Text('Plastic')),
                DropdownMenuItem(value: 'glass', child: Text('Glass')),
                DropdownMenuItem(value: 'paper', child: Text('Paper')),
                DropdownMenuItem(value: 'clothes', child: Text('Clothes')),
                DropdownMenuItem(value: 'ewaste', child: Text('E-Waste')),
                DropdownMenuItem(value: 'cans', child: Text('Cans')),
                DropdownMenuItem(value: 'unknown', child: Text('Unknown')),
              ],
              onChanged: (value) {
                materialType = value ?? materialType;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final weight = double.tryParse(weightController.text) ?? 0;
              final points = _calculatePoints(weight);
              Navigator.pop(
                context,
                record.copyWith(
                  weightKg: weight,
                  materialType: materialType,
                  points: points,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (updated != null) {
      await service.updateRecord(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = ScanHistoryService();

    return Scaffold(
      appBar: AppBar(title: const Text('Scan History'), elevation: 0),
      body: StreamBuilder<List<ScanRecord>>(
        stream: service.streamUserRecords(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final records = snapshot.data ?? [];
          if (records.isEmpty) {
            return const Center(child: Text('No scan history yet.'));
          }

          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.qr_code_scanner),
                  title: Text('${record.materialType} • ${record.weightKg} KG'),
                  subtitle: Text(
                    'Code: ${record.code}\nPoints: ${record.points}',
                  ),
                  isThreeLine: true,
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () =>
                            _showEditDialog(context, record, service),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => service.deleteRecord(record.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
