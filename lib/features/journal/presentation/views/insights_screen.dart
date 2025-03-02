import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_journal_app/core/common/widgets/section_header.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/features/journal/presentation/insights_cubit/insights_cubit.dart';
import 'package:mental_health_journal_app/features/journal/presentation/refactors/mood_sentiment_distribution.dart';
import 'package:mental_health_journal_app/features/journal/presentation/widgets/mood_trends_dashboard.dart';

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
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<InsightsCubit, InsightsState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
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
                  SectionHeader(
                    sectionTitle: 'Mood & Sentiment Trends',
                    fontSize: 16,
                    seeAll: false,
                    onSeeAll: () {},
                  ),
                  const MoodTrendsDashboard(),
                  const SizedBox(height: 35),
                  SectionHeader(
                    sectionTitle: 'Mood & Sentiment Distribution',
                    fontSize: 16,
                    seeAll: false,
                    onSeeAll: () {},
                  ),
                  const SizedBox(height: 16),

                  /// **Mood Breakdown Pie Charts**
                  const MoodSentimentDistribution(),

                  const SizedBox(height: 50),

                  /// **Recent Mood Summary**
                  // _buildEmojiMoodSummary(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
