import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_journal_app/core/enums/update_user_action.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/extensions/string_extensions.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/core/services/sentiment_analyser.dart';
import 'package:mental_health_journal_app/core/utils/core_utils.dart';
import 'package:mental_health_journal_app/features/auth/data/models/user_model.dart';
import 'package:mental_health_journal_app/features/auth/domain/entities/user.dart';
import 'package:mental_health_journal_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/presentation/journal_cubit/journal_cubit.dart';
import 'package:mental_health_journal_app/features/journal/presentation/views/journal_editor_screen.dart';

class JournalEntryDetailScreen extends StatelessWidget {
  const JournalEntryDetailScreen({
    required this.entry,
    super.key,
  });

  static const id = '/journal-entry-detail';

  final JournalEntry entry;
  void goToEditor(BuildContext context) {
    Navigator.pushNamed(
      context,
      JournalEditorScreen.id,
      arguments: entry,
    );
  }

  Future<void> deleteEntry(BuildContext context, UserEntity? currentUser) async {
    final bloc = context.read<AuthBloc>();
    await context.read<JournalCubit>().deleteEntry(
          entryId: entry.id,
        );

    final sentimentAnalyzer = SentimentAnalyzer();

    final interpretation = sentimentAnalyzer.interpretResult(
      entry.sentimentScore,
    );
    final sentimentSummary = currentUser!.sentimentSummary as SentimentSummaryModel;
    final newSentimentSummary = sentimentSummary.copyWith(
      negative: interpretation == 'Negative' ? sentimentSummary.negative - 1 : null,
      positive: interpretation == 'Positive' ? sentimentSummary.positive - 1 : null,
      neutral: interpretation == 'Neutral' ? sentimentSummary.neutral - 1 : null,
    );

    final moodSummary = currentUser.moodSummary as MoodSummaryModel;
    final newMoodSummary = moodSummary.copyWith(
      happy: entry.selectedMood == 'Happy' ? moodSummary.happy - 1 : null,
      neutral: entry.selectedMood == 'Neutral' ? moodSummary.neutral - 1 : null,
      sad: entry.selectedMood == 'Sad' ? moodSummary.sad - 1 : null,
      angry: entry.selectedMood == 'Angry' ? moodSummary.angry - 1 : null,
    );
    var tagsFrequency = currentUser.tagsFrequency;
    for (final tag in entry.tags) {
      tagsFrequency = tagsFrequency.removeTag(tag);
    }
    print('deleted tags. tagsFrequency: $tagsFrequency');
    bloc
      ..add(
        UpdateUserEvent(
          action: UpdateUserAction.totalEntries,
          userData: currentUser.totalEntries - 1,
        ),
      )
      ..add(
        UpdateUserEvent(
          action: UpdateUserAction.moodSummary,
          userData: newMoodSummary,
        ),
      )
      ..add(
        UpdateUserEvent(
          action: UpdateUserAction.sentimentSummary,
          userData: newSentimentSummary,
        ),
      )
      ..add(UpdateUserEvent(action: UpdateUserAction.tagsFrequency, userData: tagsFrequency.tags));
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.currentUser;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    final contentController = QuillController.basic();
    try {
      // Attempt to parse the content as Delta JSON
      final deltaJson = jsonDecode(entry.content);
      contentController.document = Document.fromJson(deltaJson as List);
    } on Exception catch (e) {
      // If parsing fails, treat the content as plain text
      debugPrint(e.toString());
      contentController.document = Document()..insert(0, entry.content);
    }

    return BlocListener<JournalCubit, JournalState>(
      listener: (context, state) {
        if (state is EntryDeleted) {
          CoreUtils.showSnackBar(context, 'Deleted successfully');
          Navigator.pop(context);
        } else if (state is JournalError) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Colours.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colours.backgroundColor,
          actions: [
            IconButton(
              onPressed: () => goToEditor(context),
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () async => deleteEntry(context, currentUser),
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and Sentiment
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('MMM d, yyyy').format(
                        entry.dateCreated,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Title Section
                SizedBox(
                  width: context.width * 0.70,
                  child: Text(
                    entry.title!.capitalizeFirstLetter(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Mood: ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Chip(
                          label: Text(
                            '${entry.selectedMood} '
                            '${CoreUtils.getEmoji(entry.selectedMood)}',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Sentiment: ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Chip(
                          label: Text(
                            SentimentAnalyzer().interpretResult(
                              entry.sentimentScore,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 8,
                  ).copyWith(left: 0),
                  child: QuillEditor.basic(
                    controller: contentController..readOnly = true,
                    configurations: const QuillEditorConfigurations(
                      minHeight: 300,
                      showCursor: false,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Tags Section
                if (entry.tags.isNotEmpty)
                  Row(
                    children: [
                      const Text(
                        'Tags: ',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      ...[
                        SizedBox(
                          width: context.width * 0.80,
                          child: Wrap(
                            spacing: 8,
                            children: [
                              ...entry.tags.map(
                                (tag) => Chip(
                                  color: const WidgetStatePropertyAll(
                                    Colours.backgroundColor,
                                  ),
                                  label: Text(tag),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: Colours.softGreyColor.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
