import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_journal_app/core/common/widgets/loading_widget.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/core/utils/core_utils.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/presentation/insights_cubit/insights_cubit.dart';
import 'package:mental_health_journal_app/features/journal/presentation/refactors/mood_trends_chart.dart';

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
          final moodData = <FlSpot>[];
          final sentimentData = <FlSpot>[];
          final moodCounts = <String, int>{
            'Happy': 0,
            'Neutral': 0,
            'Sad': 0,
            'Angry': 0,
          };
          if (_selectedFilter == 'Week') {
            setWeekMoodSentimentData(entries, moodData, sentimentData, moodCounts);
          } else if (_selectedFilter == 'Month') {
            setMonthMoodSentimentData(entries, moodData, sentimentData, moodCounts);
          }

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ).copyWith(top: 0, left: 4),
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
                else
                  MoodTrendsChart(
                    userMoodSpots: moodData,
                    sentimentScoreSpots: sentimentData,
                    filter: _selectedFilter,
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

  void setMonthMoodSentimentData(
    List<JournalEntry> entries,
    List<FlSpot> moodData,
    List<FlSpot> sentimentData,
    Map<String, int> moodCounts,
  ) {
    final moodMap = <int, int>{};
    final sentimentMap = <int, double>{};
    final now = DateTime.now();
    final startOfMonth = now.subtract(const Duration(days: 30));

    for (final entry in entries) {
      final daysSinceStartOfMonth = entry.dateCreated.difference(startOfMonth).inDays;
      // final weekBucket = daysSinceStartOfMonth / 7.0;
      // final xValue = 4 - weekBucket;

      final moodValue = _mapMoodToValue(entry.selectedMood);
      final sentimentValue = entry.sentimentScore;

      moodMap[daysSinceStartOfMonth] = moodValue;
      sentimentMap[daysSinceStartOfMonth] = sentimentValue;

      // if (daysSinceStartOfMonth < 0 || daysSinceStartOfMonth > 30) continue;
      // final xValue = daysSinceStartOfMonth.toDouble();

      // moodData.add(
      //   FlSpot(
      //     xValue,
      //     _mapMoodToValue(entry.selectedMood).toDouble(),
      //   ),
      // );
      //
      // sentimentData.add(FlSpot(xValue, entry.sentimentScore));
      //
      // // weeksWithEntries.add(xValue.floor());
      moodCounts[entry.selectedMood] = (moodCounts[entry.selectedMood] ?? 0) + 1;
    }

    for (var day = 0; day <= 30; day++) {
      // final xPos = 4 - i.toDouble(); // Reversed week positioning
      // if (!moodData.any((spot) => spot.x.floor() == i.toDouble())) {
      moodData.add(
        FlSpot(
          day.toDouble(),
          moodMap[day]?.toDouble() ?? 4,
        ),
      );
      sentimentData.add(
        FlSpot(
          day.toDouble(),
          sentimentMap[day]?.toDouble() ?? 0,
        ),
      );
      // }
    }
  }

  void setWeekMoodSentimentData(
    List<JournalEntry> entries,
    List<FlSpot> moodData,
    List<FlSpot> sentimentData,
    Map<String, int> moodCounts,
  ) {
    // Create a map for quick access to journal entries by day
    final moodMap = <String, int>{};
    final sentimentMap = <String, double>{};
    final labels = CoreUtils.generateRotatedWeekLabels();

    for (final entry in entries) {
      // 'Mon', 'Tue'
      final entryDay = DateFormat.E().format(entry.dateCreated);
      final moodValue = _mapMoodToValue(entry.selectedMood);
      final sentimentValue = entry.sentimentScore;

      moodMap[entryDay] = moodValue;
      sentimentMap[entryDay] = sentimentValue;

      moodCounts[entry.selectedMood] = (moodCounts[entry.selectedMood] ?? 0) + 1;
    }
    print(moodMap);
    // Assign values to spots, ensuring all weekdays are filled
    for (var i = 0; i < labels.length; i++) {
      final day = labels[i];
      moodData.add(
        FlSpot(
          i.toDouble(),
          moodMap[day]?.toDouble() ?? 4,
        ), // Default to Neutral if missing
      );
      sentimentData.add(
        FlSpot(
          i.toDouble(),
          sentimentMap[day] ?? 0,
        ), // Default to Neutral if missing
      );
    }
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
}
