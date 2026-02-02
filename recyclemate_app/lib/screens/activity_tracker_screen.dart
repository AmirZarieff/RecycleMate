import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/recycling_activity.dart';
import '../services/recycling_activity_service.dart';

/// Activity Tracker Screen - Main screen for CRUD operations
/// This screen allows users to view, add, edit, and delete recycling activities
class ActivityTrackerScreen extends StatefulWidget {
  const ActivityTrackerScreen({super.key});

  @override
  State<ActivityTrackerScreen> createState() => _ActivityTrackerScreenState();
}

class _ActivityTrackerScreenState extends State<ActivityTrackerScreen> {
  final RecyclingActivityService _activityService = RecyclingActivityService();
  final String userId = 'demo_user'; // Replace with actual user ID from Firebase Auth

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Tracker'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.pushNamed(context, '/progress-summary');
            },
            tooltip: 'View Progress',
          ),
        ],
      ),
      body: StreamBuilder<List<RecyclingActivity>>(
        stream: _activityService.getUserActivities(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final activities = snapshot.data ?? [];

          if (activities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.recycling, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No activities yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to log your first recycling activity',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _ActivityCard(
                activity: activity,
                onEdit: () => _showAddEditDialog(context, activity: activity),
                onDelete: () => _confirmDelete(context, activity),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Log Activity'),
      ),
    );
  }

  /// Show dialog to add or edit an activity
  void _showAddEditDialog(BuildContext context, {RecyclingActivity? activity}) {
    showDialog(
      context: context,
      builder: (context) => _AddEditActivityDialog(
        activity: activity,
        userId: userId,
        onSave: (newActivity) async {
          try {
            if (activity == null) {
              // Add new activity
              await _activityService.addActivity(newActivity);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Activity added successfully')),
                );
              }
            } else {
              // Update existing activity
              await _activityService.updateActivity(
                newActivity.copyWith(id: activity.id),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Activity updated successfully')),
                );
              }
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          }
        },
      ),
    );
  }

  /// Confirm deletion of an activity
  void _confirmDelete(BuildContext context, RecyclingActivity activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Activity'),
        content: const Text('Are you sure you want to delete this activity?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _activityService.deleteActivity(activity.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Activity deleted')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Activity Card Widget
class _ActivityCard extends StatelessWidget {
  final RecyclingActivity activity;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ActivityCard({
    required this.activity,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: _getMaterialIcon(activity.materialType),
        title: Text(
          activity.materialType,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${activity.weight} KG • ${activity.points} points'),
            Text(
              DateFormat('MMM dd, yyyy').format(activity.date),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            if (activity.notes != null && activity.notes!.isNotEmpty)
              Text(
                activity.notes!,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: onEdit,
              color: Colors.blue,
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: onDelete,
              color: Colors.red,
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _getMaterialIcon(String materialType) {
    final iconMap = {
      'Plastic': Icons.shopping_bag,
      'Glass': Icons.broken_image,
      'Paper': Icons.description,
      'Cans': Icons.local_drink,
      'E-Waste': Icons.devices,
      'Clothes': Icons.checkroom,
    };

    final colorMap = {
      'Plastic': Colors.blue,
      'Glass': Colors.cyan,
      'Paper': Colors.orange,
      'Cans': Colors.grey,
      'E-Waste': Colors.red,
      'Clothes': Colors.purple,
    };

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colorMap[materialType]?.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconMap[materialType] ?? Icons.recycling,
        color: colorMap[materialType],
      ),
    );
  }
}

/// Add/Edit Activity Dialog
class _AddEditActivityDialog extends StatefulWidget {
  final RecyclingActivity? activity;
  final String userId;
  final Function(RecyclingActivity) onSave;

  const _AddEditActivityDialog({
    this.activity,
    required this.userId,
    required this.onSave,
  });

  @override
  State<_AddEditActivityDialog> createState() => _AddEditActivityDialogState();
}

class _AddEditActivityDialogState extends State<_AddEditActivityDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _materialType;
  late TextEditingController _weightController;
  late TextEditingController _notesController;
  late DateTime _selectedDate;

  final List<String> _materialTypes = [
    'Plastic',
    'Glass',
    'Paper',
    'Cans',
    'E-Waste',
    'Clothes',
  ];

  @override
  void initState() {
    super.initState();
    _materialType = widget.activity?.materialType ?? _materialTypes[0];
    _weightController = TextEditingController(
      text: widget.activity?.weight.toString() ?? '',
    );
    _notesController = TextEditingController(
      text: widget.activity?.notes ?? '',
    );
    _selectedDate = widget.activity?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.activity == null ? 'Add Activity' : 'Edit Activity'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _materialType,
                decoration: const InputDecoration(
                  labelText: 'Material Type',
                  border: OutlineInputBorder(),
                ),
                items: _materialTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _materialType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (KG)',
                  border: OutlineInputBorder(),
                  suffixText: 'KG',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter weight';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Weight must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final weight = double.parse(_weightController.text);
              final points = RecyclingActivity.calculatePoints(_materialType, weight);

              final activity = RecyclingActivity(
                id: widget.activity?.id ?? '',
                userId: widget.userId,
                materialType: _materialType,
                weight: weight,
                points: points,
                date: _selectedDate,
                notes: _notesController.text.isEmpty ? null : _notesController.text,
                status: 'completed',
              );

              widget.onSave(activity);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
