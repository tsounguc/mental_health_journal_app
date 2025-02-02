import 'package:equatable/equatable.dart';

class JournalEntry extends Equatable {
  const JournalEntry({
    required this.id,
    required this.userId,
    required this.content,
    required this.dateCreated,
    required this.selectedMood,
    required this.sentimentScore,
    required this.tags,
    this.title,
    this.titleLowercase,
  });
  JournalEntry.empty()
      : this(
          id: '',
          userId: '',
          content: '',
          dateCreated: DateTime.now(),
          selectedMood: '',
          sentimentScore: 0,
          tags: const [],
        );

  final String id;
  final String userId;
  final String? title;
  final String? titleLowercase;
  final String content;
  final DateTime dateCreated;
  final String selectedMood;
  final double sentimentScore;
  final List<String> tags;

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        titleLowercase,
        content,
        dateCreated,
        selectedMood,
        sentimentScore,
        tags,
      ];

  @override
  String toString() => '''
        JournalEntry {
          id: $id,
          userId: $userId,
          title: $title,
          title_lowercase: $titleLowercase
          content: $content,
          dateCreated: $dateCreated,
          selectedMood: $selectedMood,
          sentimentScore: $sentimentScore,
          tags: $tags,
        }
      ''';
}
