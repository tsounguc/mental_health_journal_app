import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/services/sentiment_analyser.dart';
import 'package:mental_health_journal_app/core/utils/core_utils.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';

class EntryCard extends StatelessWidget {
  const EntryCard({
    required this.entry,
    this.onTap,
    super.key,
  });

  final JournalEntry entry;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Document? document;
    try {
      final deltaJson = jsonDecode(entry.content);

      document = Document.fromJson(deltaJson as List);
    } on Exception catch (e) {
      debugPrint(e.toString());
      document = Document()..insert(0, entry.content);
    }

    final content = document.toPlainText();

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: context.theme.scaffoldBackgroundColor,
        margin: const EdgeInsets.symmetric(
          vertical: 20,
        ).copyWith(top: 0),
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 14,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.title ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    DateFormat('MMM d, yyyy').format(entry.dateCreated),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  SizedBox(
                    width: context.width * 0.7,
                    child: Text(
                      content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
