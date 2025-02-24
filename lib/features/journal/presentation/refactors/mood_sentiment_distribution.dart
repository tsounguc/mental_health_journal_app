import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/common/app/providers/user_provider.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/features/journal/presentation/widgets/mood_pie_chart.dart';
import 'package:provider/provider.dart';

class MoodSentimentDistribution extends StatelessWidget {
  const MoodSentimentDistribution({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        final user = context.currentUser;
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 40,
          ).copyWith(top: 0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// **Mood Breakdown Pie Chart**
              MoodPieChart(
                moodSummary: user?.moodSummary,
                sentimentSummary: user?.sentimentSummary,
                totalEntries: user?.totalEntries ?? 0,
              ),
            ],
          ),
        );
      },
    );
  }
}
