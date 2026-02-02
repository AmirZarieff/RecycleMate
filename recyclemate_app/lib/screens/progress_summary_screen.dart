import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../services/recycling_activity_service.dart';

/// Progress Summary Screen - Shows weekly/monthly recycling progress with charts
class ProgressSummaryScreen extends StatefulWidget {
  const ProgressSummaryScreen({super.key});

  @override
  State<ProgressSummaryScreen> createState() => _ProgressSummaryScreenState();
}

class _ProgressSummaryScreenState extends State<ProgressSummaryScreen> {
  final RecyclingActivityService _activityService = RecyclingActivityService();
  final String userId = 'demo_user'; // Replace with actual user ID
  String _selectedPeriod = 'weekly'; // 'weekly', 'monthly', 'all-time'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Summary'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Period Selector
            Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _PeriodButton(
                      label: 'Weekly',
                      isSelected: _selectedPeriod == 'weekly',
                      onTap: () => setState(() => _selectedPeriod = 'weekly'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _PeriodButton(
                      label: 'Monthly',
                      isSelected: _selectedPeriod == 'monthly',
                      onTap: () => setState(() => _selectedPeriod = 'monthly'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _PeriodButton(
                      label: 'All Time',
                      isSelected: _selectedPeriod == 'all-time',
                      onTap: () => setState(() => _selectedPeriod = 'all-time'),
                    ),
                  ),
                ],
              ),
            ),

            // Summary Cards
            FutureBuilder<Map<String, dynamic>>(
              future: _getSummaryData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                }

                final summary = snapshot.data ?? {};
                final totalWeight = summary['totalWeight'] ?? 0.0;
                final totalPoints = summary['totalPoints'] ?? 0;
                final totalActivities = summary['totalActivities'] ?? 0;
                final materialBreakdown =
                    summary['materialBreakdown'] as Map<String, double>? ?? {};

                return Column(
                  children: [
                    // Summary Stats Cards
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              icon: Icons.recycling,
                              label: 'Total Weight',
                              value: '${totalWeight.toStringAsFixed(1)} KG',
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.star,
                              label: 'Total Points',
                              value: '$totalPoints',
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _StatCard(
                        icon: Icons.list_alt,
                        label: 'Activities Logged',
                        value: '$totalActivities',
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Material Breakdown Pie Chart
                    if (materialBreakdown.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Material Breakdown',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _MaterialBreakdownChart(
                              materialBreakdown: materialBreakdown,
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _getSummaryData() {
    switch (_selectedPeriod) {
      case 'weekly':
        return _activityService.getWeeklySummary(userId);
      case 'monthly':
        return _activityService.getMonthlySummary(userId);
      case 'all-time':
        return _activityService.getAllTimeSummary(userId);
      default:
        return _activityService.getWeeklySummary(userId);
    }
  }
}

/// Period Selection Button
class _PeriodButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

/// Stat Card Widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Material Breakdown Pie Chart
class _MaterialBreakdownChart extends StatelessWidget {
  final Map<String, double> materialBreakdown;

  const _MaterialBreakdownChart({required this.materialBreakdown});

  @override
  Widget build(BuildContext context) {
    final colorMap = {
      'Plastic': Colors.blue,
      'Glass': Colors.cyan,
      'Paper': Colors.orange,
      'Cans': Colors.grey,
      'E-Waste': Colors.red,
      'Clothes': Colors.purple,
    };

    // Sort materials by weight (descending)
    final sortedEntries = materialBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final total = materialBreakdown.values.reduce((a, b) => a + b);

    final sections = sortedEntries.map((entry) {
      final color = colorMap[entry.key] ?? Colors.green;
      final percentage = (entry.value / total * 100);

      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: percentage >= 5 ? '${percentage.toStringAsFixed(0)}%' : '',
        radius: 85,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black26,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
        titlePositionPercentageOffset: 0.55,
      );
    }).toList();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Pie Chart
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  sectionsSpace: 2,
                  centerSpaceRadius: 35,
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Legend with divider
            Container(
              padding: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: sortedEntries.map((entry) {
                  final color = colorMap[entry.key] ?? Colors.green;
                  final percentage = (entry.value / total * 100);
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: color.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: color.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${entry.value.toStringAsFixed(1)} KG (${percentage.toStringAsFixed(1)}%)',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Daily Activity Bar Chart
class _DailyActivityChart extends StatelessWidget {
  final List<Map<String, dynamic>> dailyData;

  const _DailyActivityChart({required this.dailyData});

  @override
  Widget build(BuildContext context) {
    final maxWeight = dailyData.isEmpty
        ? 10.0
        : dailyData.map((d) => d['weight'] as double).reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        maxY: maxWeight > 0 ? maxWeight * 1.2 : 10,
        barGroups: dailyData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data['weight'] as double,
                color: Colors.green,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < dailyData.length) {
                  final date = dailyData[value.toInt()]['date'] as DateTime;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      DateFormat('E').format(date),
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
