import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MoodPieChart extends StatelessWidget {
  const MoodPieChart({
    required this.moodCounts,
    required this.totalEntries,
    super.key,
  });

  /// Mood frequency counts
  final Map<String, int> moodCounts;
  final int totalEntries;

  @override
  Widget build(BuildContext context) {
    final totalEntries = moodCounts.values.fold(0, (sum, count) => sum + count);
    if (totalEntries == 0) {
      return const Center(child: Text("No data available"));
    }

    /// Convert mood counts into pie chart sections
    final List<PieChartSectionData> sections = _generateChartSections(moodCounts, totalEntries);

    return Column(
      children: [
        /// 🎯 **Pie Chart**
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
              startDegreeOffset: 180, // Rotate for better visibility
              borderData: FlBorderData(show: false),
            ),
          ),
        ),

        const SizedBox(height: 10),

        /// 🎨 **Legend**
        _buildLegend(),
      ],
    );
  }

  /// 🎯 **Generate Pie Chart Sections from Mood Counts**
  List<PieChartSectionData> _generateChartSections(Map<String, int> moodCounts, int totalEntries) {
    return moodCounts.entries.map((entry) {
      final mood = entry.key;
      final count = entry.value;
      final percentage = (count / totalEntries) * 100;

      return PieChartSectionData(
        color: _getMoodColor(mood),
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  /// 🎨 **Legend for Mood Colors**
  Widget _buildLegend() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      children: [
        _legendItem(Colors.green, "Happy"),
        _legendItem(Colors.blue, "Neutral"),
        _legendItem(Colors.orange, "Sad"),
        _legendItem(Colors.red, "Angry"),
      ],
    );
  }

  /// 🎨 **Legend Item (Color + Label)**
  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  /// 🎨 **Map Mood to Colors**
  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return Colors.green;
      case 'neutral':
        return Colors.blue;
      case 'sad':
        return Colors.orange;
      case 'angry':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
