import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/extensions/string_extensions.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/core/services/sentiment_analyser.dart';
import 'package:mental_health_journal_app/core/utils/core_utils.dart';
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

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  JournalEditorScreen.id,
                  arguments: entry,
                );
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                context.read<JournalCubit>().deleteEntry(entryId: entry.id);
              },
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
                        )
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
                        )
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
                        Wrap(
                          spacing: 8,
                          children: [
                            ...entry.tags.map(
                              (tag) => Chip(
                                color: const WidgetStatePropertyAll(Colours.backgroundColor),
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
                            )
                          ],
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
