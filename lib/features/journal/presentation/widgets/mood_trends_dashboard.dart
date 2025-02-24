import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_journal_app/core/common/widgets/loading_widget.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/core/utils/core_utils.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/presentation/insights_cubit/insights_cubit.dart';
import 'package:mental_health_journal_app/features/journal/presentation/refactors/mood_trends_chart.dart';
import 'package:mental_health_journal_app/features/journal/presentation/widgets/insights_carousel.dart';

class MoodTrendsDashboard extends StatefulWidget {
  const MoodTrendsDashboard({super.key});

  @override
  State<MoodTrendsDashboard> createState() => _MoodTrendsDashboardState();
}

class _MoodTrendsDashboardState extends State<MoodTrendsDashboard> {
  String _selectedFilter = 'Week';
  final List<String> _filters = ['Week', 'Month', 'Year'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InsightsCubit, InsightsState>(
      builder: (context, state) {
        if (state is DashboardDataFetched) {
          final entries = state.entries;
          // Extract mood and sentiment data points for the last 7 days
          final moodActualLine = <FlSpot>[];
          final sentimentActualLine = <FlSpot>[];
          final moodFullLine = <FlSpot>[];
          final sentimentFullLine = <FlSpot>[];
          final moodCounts = <String, int>{
            'Happy': 0,
            'Neutral': 0,
            'Sad': 0,
            'Angry': 0,
          };

          setMoodSentimentData(
            _selectedFilter,
            entries,
            moodFullLine,
            sentimentFullLine,
            moodActualLine,
            sentimentActualLine,
            moodCounts,
          );

          final insights = CoreUtils.generateMoodInsights(entries, _selectedFilter);

          return Container(
            padding: const EdgeInsets.only(
              left: 4,
              right: 16,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: _filters.map((String filter) {
                    return DropdownMenuItem<String>(
                      value: filter,
                      child: Text(filter),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                      final userId = context.currentUser!.uid;
                      context.read<InsightsCubit>().getDashboardData(
                            userId: userId,
                            range: _selectedFilter,
                          );
                    });
                  },
                ),

                /// **Mood & Sentiment Graph**
                if (entries.isEmpty)
                  const SizedBox(
                    height: 225,
                    child: Center(
                      child: Text(
                        'No mood trends available yet.',
                        style: TextStyle(
                          color: Colours.softGreyColor,
                        ),
                      ),
                    ),
                  )
                else ...[
                  MoodTrendsChart(
                    moodActualLine: moodActualLine,
                    sentimentActualLine: sentimentActualLine,
                    moodFullLine: moodFullLine,
                    sentimentFullLine: sentimentFullLine,
                    filter: _selectedFilter,
                  ),
                  InsightsCarousel(insights: insights),
                ],
              ],
            ),
          );
        } else if (state is DashboardLoading) {
          return const LoadingWidget();
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 16,
            ).copyWith(top: 8, bottom: 25),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const Center(
              child: Text('Failed to load mood trends'),
            ),
          );
        }
      },
    );
  }

  void setMoodSentimentData(
    String filter,
    List<JournalEntry> entries,
    List<FlSpot> moodFullLine,
    List<FlSpot> sentimentFullLine,
    List<FlSpot> moodActualLine,
    List<FlSpot> sentimentActualLine,
    Map<String, int> moodCounts,
  ) {
    final range = filter == 'Week'
        ? 6
        : filter == 'Month'
            ? 30
            : 365;

    final now = DateTime.now();
    final dateNow = DateTime(now.year, now.month, now.day);
    final startOfRange = dateNow.subtract(Duration(days: range));

    // Create a map for quick access to journal entries by day
    final moodMap = <int, double>{};
    final sentimentMap = <int, double>{};

    for (final entry in entries) {
      // 'Mon', 'Tue'
      final dateOfEntry = DateTime(
        entry.dateCreated.year,
        entry.dateCreated.month,
        entry.dateCreated.day,
      );
      final diff = dateOfEntry.difference(startOfRange).inDays;
      if (diff < 0 || diff > range) continue;

      final moodValue = CoreUtils.mapMoodToValue(entry.selectedMood).toDouble();
      final sentimentValue = entry.sentimentScore;

      moodMap[diff] = moodValue;
      sentimentMap[diff] = sentimentValue;

      moodCounts[entry.selectedMood] = (moodCounts[entry.selectedMood] ?? 0) + 1;
    }

    // Assign values to spots, ensuring all weekdays are filled
    for (var day = 0; day <= range; day++) {
      final moodVal = moodMap[day] ?? 4;
      final sentimentVal = sentimentMap[day] ?? 0;

      moodFullLine.add(FlSpot(day.toDouble(), moodVal));
      sentimentFullLine.add(FlSpot(day.toDouble(), sentimentVal));
    }

    moodMap.forEach((day, val) {
      moodActualLine.add(FlSpot(day.toDouble(), val));
    });
    sentimentMap.forEach((day, val) {
      sentimentActualLine.add(FlSpot(day.toDouble(), val));
    });
  }
}
