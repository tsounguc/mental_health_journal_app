import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_journal_app/core/common/widgets/section_header.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/features/journal/presentation/insights_cubit/insights_cubit.dart';
import 'package:mental_health_journal_app/features/journal/presentation/journal_cubit/journal_cubit.dart';
import 'package:mental_health_journal_app/features/journal/presentation/refactors/journal_home_header.dart';
import 'package:mental_health_journal_app/features/journal/presentation/refactors/recent_journal_entries.dart';
import 'package:mental_health_journal_app/features/journal/presentation/views/journal_editor_screen.dart';
import 'package:mental_health_journal_app/features/journal/presentation/views/safe_mode_screen.dart';
import 'package:mental_health_journal_app/features/journal/presentation/widgets/animated_fab.dart';
import 'package:mental_health_journal_app/features/journal/presentation/widgets/mood_trends_dashboard.dart';

class JournalHomeScreen extends StatefulWidget {
  const JournalHomeScreen({super.key});

  static const id = '/journal-home';

  @override
  State<JournalHomeScreen> createState() => _JournalHomeScreenState();
}

class _JournalHomeScreenState extends State<JournalHomeScreen> {
  final ScrollController _scrollController = ScrollController();

  void getEntries() {
    context.read<JournalCubit>().getEntries(
          userId: context.currentUser?.uid ?? '',
        );
  }

  void getDashboardData() {
    context.read<InsightsCubit>().getDashboardData(
          userId: context.currentUser?.uid ?? '',
        );
  }

  void _onScroll() {
    final scrollTrigger = _scrollController.position.maxScrollExtent * 0.8;
    if (_scrollController.position.pixels >= scrollTrigger) {
      final cubit = context.read<JournalCubit>();
      if (cubit.state is EntriesFetched) {
        cubit.getEntries(
          userId: context.currentUser!.uid,
          loadMore: true,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    getEntries();
    getDashboardData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      backgroundColor: Colours.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const JournalHomeHeader(),
              SectionHeader(
                sectionTitle: 'Mood & Sentiment Trends',
                fontSize: 16,
                seeAll: false,
                onSeeAll: () {},
              ),
              const MoodTrendsDashboard(),
              // const SizedBox(height: 6),
              SectionHeader(
                sectionTitle: 'Recent Entries',
                fontSize: 16,
                seeAll: false,
                onSeeAll: () {},
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: RecentJournalEntries(
                    scrollController: _scrollController,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const AnimatedFAB(),
    );
  }
}
