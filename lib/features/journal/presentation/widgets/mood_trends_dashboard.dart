import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_journal_app/core/common/widgets/loading_widget.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/features/journal/presentation/insights_cubit/insights_cubit.dart';
import 'package:mental_health_journal_app/features/journal/presentation/refactors/mood_trends_chart.dart';

class MoodTrendsDashboard extends StatelessWidget {
  const MoodTrendsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InsightsCubit, InsightsState>(
      builder: (context, state) {
        if (state is DashboardDataFetched) {
          final entries = state.entries;

          // Extract mood and sentiment data points for the last 7 days
          final moodData = <FlSpot>[];
          final sentimentData = <FlSpot>[];
          final moodCounts = <String, int>{
            'Happy': 0,
            'Neutral': 0,
            'Sad': 0,
            'Angry': 0,
          };
          final dayLabels =
              _generateRotatedWeekLabels(); // Get reordered week labels/ Stores the day labels (e.g., 'Mon', 'Tue')

          // Create a map for quick access to journal entries by day
          final moodMap = <String, int>{};
          final sentimentMap = <String, double>{};

          for (final entry in entries) {
            final entryDay = DateFormat.E().format(entry.dateCreated); // 'Mon', 'Tue'
            final moodValue = _mapMoodToValue(entry.selectedMood);
            final sentimentValue = entry.sentimentScore;

            moodMap[entryDay] = moodValue;
            sentimentMap[entryDay] = sentimentValue;

            moodCounts[entry.selectedMood] = (moodCounts[entry.selectedMood] ?? 0) + 1;
          }

          // Assign values to spots, ensuring all weekdays are filled
          for (var i = 0; i < dayLabels.length; i++) {
            final day = dayLabels[i];

            moodData.add(
              FlSpot(i.toDouble(), moodMap[day]?.toDouble() ?? 4), // Default to Neutral if missing
            );
            sentimentData.add(
              FlSpot(i.toDouble(), sentimentMap[day] ?? 0), // Default to Neutral if missing
            );
          }
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ).copyWith(top: 8, left: 4),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                else
                  MoodTrendsChart(
                    userMoodSpots: moodData,
                    sentimentScoreSpots: sentimentData,
                    dayLabels: dayLabels,
                  ),
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

  /// Maps user-selected moods to numerical values for the graph
  int _mapMoodToValue(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return 5;
      case 'neutral':
        return 4;
      case 'sad':
        return 3;
      case 'angry':
        return 2;
      default:
        return 4; // Default to neutral
    }
  }

  /// Generates a list of weekdays starting from today (e.g., If today is Wed, list starts at 'Wed')
  List<String> _generateRotatedWeekLabels() {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final todayIndex = DateTime.now().weekday; // Convert to zero-based index
    return [
      ...weekdays.sublist(todayIndex),
      ...weekdays.sublist(0, todayIndex),
    ];
  }
}
