import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';

class JournalEntryModel extends JournalEntry {
  const JournalEntryModel({
    required super.id,
    required super.userId,
    required super.content,
    required super.dateCreated,
    required super.tags,
    required super.sentiment,
    super.title,
    super.titleLowercase,
  });

  JournalEntryModel.empty()
      : this(
          id: '_empty.id',
          userId: '_empty.userId',
          content: '{}',
          dateCreated: DateTime.now(),
          tags: const [],
          sentiment: 'neutral',
          title: null,
          titleLowercase: null,
        );
  JournalEntryModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String? ?? '',
          userId: map['userId'] as String? ?? '',
          content: map['content'] as String? ?? '{}',
          dateCreated: (map['dateCreated'] as Timestamp?)?.toDate() ?? DateTime.now(),
          tags: map['tags'] != null ? List<String>.from(map['tags'] as List) : [],
          sentiment: map['sentiment'] as String? ?? '',
          title: map['title'] as String? ?? '',
          titleLowercase: map['title_lowercase'] as String? ?? '',
        );

  DataMap toMap() => {
        'id': id,
        'userId': userId,
        'content': content,
        'dateCreated': Timestamp.fromDate(dateCreated),
        'tags': tags,
        'sentiment': sentiment,
        'title': title,
        'title_lowercase': titleLowercase,
      };

  JournalEntryModel copyWith({
    String? id,
    String? userId,
    String? content,
    DateTime? dateCreated,
    List<String>? tags,
    String? sentiment,
    String? title,
    String? titleLowercase,
  }) {
    return JournalEntryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      titleLowercase: titleLowercase ?? this.titleLowercase,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      dateCreated: dateCreated ?? this.dateCreated,
      tags: tags ?? this.tags,
      sentiment: sentiment ?? this.sentiment,
    );
  }
}
