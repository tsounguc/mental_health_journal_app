import 'package:equatable/equatable.dart';

class JournalEntry extends Equatable {
  const JournalEntry({
    required this.id,
    required this.userId,
    required this.content,
    required this.dateCreated,
    required this.tags,
    required this.sentiment,
    this.title,
  });
  JournalEntry.empty()
      : this(
          id: '',
          userId: '',
          content: '',
          dateCreated: DateTime.now(),
          tags: const [],
          sentiment: '',
        );

  final String id;
  final String userId;
  final String? title;
  final String content;
  final DateTime dateCreated;
  final List<String> tags;
  final String sentiment;

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        content,
        dateCreated,
        tags,
        sentiment,
      ];

  @override
  String toString() => '''
        JournalEntry {
          id: $id,
          userId: $userId,
          title: $title,
          content: $content,
          dateCreated: $dateCreated,
          tags: $tags,
          sentiment: $sentiment,
        }
      ''';
}
