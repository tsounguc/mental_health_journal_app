import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/common/widgets/section_header.dart';
import 'package:mental_health_journal_app/features/auth/domain/entities/user.dart';

class MoodPieChart extends StatelessWidget {
  const MoodPieChart({
    required this.moodSummary,
    required this.totalEntries,
    required this.sentimentSummary,
    super.key,
  });

  /// Mood frequency counts
  final MoodSummary? moodSummary;
  final SentimentSummary? sentimentSummary;
  final int totalEntries;

  @override
  Widget build(BuildContext context) {
    if (totalEntries == 0) {
      return const Center(child: Text('No data available'));
    }

    /// Convert mood counts into pie chart sections
    final (moodSections, sentimentSections) = _generateChartSections(
      moodSummary,
      sentimentSummary,
      totalEntries,
    );

    return Column(
      children: [
        /// **Pie Chart**
        SectionHeader(
          sectionTitle: 'Mood: ',
          fontSize: 14,
          seeAll: false,
          onSeeAll: () {},
        ),
        SizedBox(
          height: 150,
          child: PieChart(
            PieChartData(
              sections: moodSections,
              centerSpaceRadius: 10,
              sectionsSpace: 1,
              startDegreeOffset: 180, // Rotate for better visibility
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildMoodLegend(),

        const SizedBox(height: 25),

        /// **Pie Chart**
        SectionHeader(
          sectionTitle: 'Sentiment: ',
          fontSize: 14,
          seeAll: false,
          onSeeAll: () {},
        ),
        SizedBox(
          height: 150,
          child: PieChart(
            PieChartData(
              sections: sentimentSections,
              centerSpaceRadius: 10,
              sectionsSpace: 1,
              startDegreeOffset: 180, // Rotate for better visibility
              borderData: FlBorderData(show: false),
            ),
          ),
        ),

        const SizedBox(height: 20),

        /// **Legend**
        _buildSentimentLegend(),
      ],
    );
  }

  /// **Generate Pie Chart Sections from Mood Counts**
  (List<PieChartSectionData>, List<PieChartSectionData>) _generateChartSections(
    MoodSummary? moodSummary,
    SentimentSummary? sentimentSummary,
    int totalEntries,
  ) {
    final happyPercentage = (moodSummary?.happy ?? 0) / totalEntries * 100;
    final neutralPercentage = (moodSummary?.neutral ?? 0) / totalEntries * 100;
    final sadPercentage = (moodSummary?.sad ?? 0) / totalEntries * 100;
    final angryPercentage = (moodSummary?.angry ?? 0) / totalEntries * 100;

    final positivePercentage = (sentimentSummary?.positive ?? 0) / totalEntries * 100;
    final neutralAIPercentage = (sentimentSummary?.neutral ?? 0) / totalEntries * 100;
    final negativePercentage = (sentimentSummary?.negative ?? 0) / totalEntries * 100;

    const titleStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    final moodSections = [
      PieChartSectionData(
        color: _getMoodColor('happy'),
        value: happyPercentage,
        title: '${happyPercentage.toStringAsFixed(0)}%',
        titlePositionPercentageOffset: happyPercentage < 7 ? 1.16 : null,
        radius: 60,
        titleStyle: titleStyle.copyWith(
          color: happyPercentage < 7 ? Colors.black : null,
        ),
      ),
      PieChartSectionData(
        color: _getMoodColor('neutral'),
        value: neutralPercentage,
        title: '${neutralPercentage.toStringAsFixed(0)}%',
        titlePositionPercentageOffset: neutralPercentage < 7 ? 1.16 : null,
        radius: 60,
        titleStyle: titleStyle.copyWith(
          color: neutralPercentage < 7 ? Colors.black : null,
        ),
      ),
      PieChartSectionData(
        color: _getMoodColor('sad'),
        value: sadPercentage,
        title: '${sadPercentage.toStringAsFixed(0)}%',
        titlePositionPercentageOffset: sadPercentage < 7 ? 1.16 : null,
        radius: 60,
        titleStyle: titleStyle.copyWith(
          color: sadPercentage < 7 ? Colors.black : null,
        ),
      ),
      PieChartSectionData(
        color: _getMoodColor('angry'),
        value: angryPercentage,
        title: '${angryPercentage.toStringAsFixed(0)}%',
        titlePositionPercentageOffset: angryPercentage < 7 ? 1.16 : null,
        radius: 60,
        titleStyle: titleStyle.copyWith(
          color: angryPercentage < 7 ? Colors.black : null,
        ),
      ),
    ];

    final sentimentSections = [
      PieChartSectionData(
        color: _getSentimentColor('positive'),
        value: positivePercentage,
        title: '${positivePercentage.toStringAsFixed(0)}%',
        titlePositionPercentageOffset: positivePercentage < 7 ? 1.16 : null,
        radius: 60,
        titleStyle: titleStyle.copyWith(
          color: positivePercentage < 7 ? Colors.black : null,
        ),
      ),
      PieChartSectionData(
        color: _getSentimentColor('neutral'),
        value: neutralAIPercentage,
        title: '${neutralAIPercentage.toStringAsFixed(0)}%',
        titlePositionPercentageOffset: neutralAIPercentage < 7 ? 1.16 : null,
        radius: 60,
        titleStyle: titleStyle.copyWith(
          color: neutralAIPercentage < 7 ? Colors.black : null,
        ),
      ),
      PieChartSectionData(
        color: _getSentimentColor('negative'),
        value: negativePercentage,
        title: '${negativePercentage.toStringAsFixed(0)}%',
        titlePositionPercentageOffset: negativePercentage < 7 ? 1.16 : null,
        radius: 60,
        titleStyle: titleStyle.copyWith(
          color: negativePercentage < 7 ? Colors.black : null,
        ),
      ),
    ];

    return (moodSections, sentimentSections);
  }

  /// **Legend for Mood Colors**
  Widget _buildMoodLegend() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      children: [
        _legendItem(Colors.green, 'Happy'),
        _legendItem(Colors.blue, 'Neutral'),
        _legendItem(Colors.orange, 'Sad'),
        _legendItem(Colors.red, 'Angry'),
      ],
    );
  }

  Widget _buildSentimentLegend() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      children: [
        _legendItem(Colors.green, 'Positive'),
        _legendItem(Colors.amber, 'Neutral'),
        _legendItem(Colors.red, 'Negative'),
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

  Color _getSentimentColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'positive':
        return Colors.green;
      case 'neutral':
        return Colors.amber;
      case 'negative':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
