import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_journal_app/core/common/widgets/loading_widget.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/core/services/sentiment_analyser.dart';
import 'package:mental_health_journal_app/features/journal/presentation/insights_cubit/insights_cubit.dart';
import 'package:mental_health_journal_app/features/journal/presentation/refactors/mood_trends_chart.dart';
import 'package:mental_health_journal_app/features/journal/presentation/widgets/mood_pie_chart.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  void getDashboardData() {
    context.read<InsightsCubit>().getDashboardData(
          userId: context.currentUser?.uid ?? '',
        );
  }

  @override
  void initState() {
    super.initState();
    getDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.backgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colours.backgroundColor,
        backgroundColor: Colours.backgroundColor,
        title: const Text('Insights'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<InsightsCubit, InsightsState>(
          builder: (context, state) {
            if (state is DashboardDataFetched) {
              final entries = state.entries;

              if (entries.isEmpty) {
                return const Center(
                  child: Text('No mood trends available yet.'),
                );
              }

              final sentimentAnalyzer = SentimentAnalyzer();

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
              var totalEntries = 0;

              // Create a map for quick access to journal entries by day
              final moodMap = <String, int>{};
              final sentimentMap = <String, double>{};

              for (final entry in entries) {
                final entryDay = DateFormat.E().format(
                  // 'Mon', 'Tue'
                  entry.dateCreated,
                );
                final moodValue = _mapMoodToValue(entry.selectedMood);
                final sentimentValue = entry.sentimentScore;

                moodMap[entryDay] = moodValue;
                sentimentMap[entryDay] = sentimentValue;

                moodCounts[entry.selectedMood] = (moodCounts[entry.selectedMood] ?? 0) + 1;
                totalEntries++;
              }

              // Assign values to spots, ensuring all weekdays are filled
              for (var i = 0; i < dayLabels.length; i++) {
                final day = dayLabels[i];

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
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 40,
                ).copyWith(bottom: 25),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mood & Sentiment Trends',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// 📊 **Mood & Sentiment Graph**
                    MoodTrendsChart(
                      userMoodSpots: moodData,
                      sentimentScoreSpots: sentimentData,
                      filter: 'Week',
                    ),

                    const SizedBox(height: 50),
                    const Text(
                      'Mood pie chart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// **Mood Breakdown Pie Chart**
                    MoodPieChart(
                      moodCounts: moodCounts,
                      totalEntries: totalEntries,
                    ),

                    const SizedBox(height: 50),

                    /// **Recent Mood Summary**
                    _buildEmojiMoodSummary(moodCounts, totalEntries),
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
        ),
      ),
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

  /// **Emoji-Based Mood Summary**
  Widget _buildEmojiMoodSummary(Map<String, int> moodCounts, int totalEntries) {
    return Column(
      children: [
        const Text(
          'Mood Summary This Week:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 15),
            _moodSummaryItem(
              '😊',
              'Happy',
              moodCounts['Happy'],
              totalEntries,
            ),
            const SizedBox(width: 15),
            _moodSummaryItem(
              '😐',
              'Neutral',
              moodCounts['Neutral'],
              totalEntries,
            ),
            const SizedBox(width: 15),
            _moodSummaryItem(
              '😢',
              'Sad',
              moodCounts['Sad'],
              totalEntries,
            ),
            const SizedBox(width: 15),
            _moodSummaryItem(
              '😠',
              'Angry',
              moodCounts['Angry'],
              totalEntries,
            ),
            const SizedBox(width: 25),
          ],
        ),
      ],
    );
  }

  /// **Mood Summary Widget**
  Widget _moodSummaryItem(String emoji, String label, int? count, int total) {
    final percentage = ((count ?? 0) / total * 100).toStringAsFixed(0);
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        Text('$percentage%', style: const TextStyle(fontSize: 14)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  /// Generates a list of weekdays starting from
  /// today (e.g., If today is Wed, list starts at 'Wed')
  List<String> _generateRotatedWeekLabels() {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final todayIndex = DateTime.now().weekday; // Convert to zero-based index
    return [
      ...weekdays.sublist(todayIndex),
      ...weekdays.sublist(0, todayIndex),
    ];
  }
}
