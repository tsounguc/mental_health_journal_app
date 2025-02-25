import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.dateCreated,
    required this.totalEntries,
    required this.sentimentSummary,
    required this.moodSummary,
    required this.tagsFrequency,
    required this.isVerified,
    this.profilePictureUrl,
  });

  UserEntity.empty()
      : this(
          uid: '',
          name: '',
          email: '',
          dateCreated: DateTime.now(),
          totalEntries: 0,
          sentimentSummary: const SentimentSummary.empty(),
          moodSummary: const MoodSummary.empty(),
          tagsFrequency: TagsFrequency.empty(),
          profilePictureUrl: '',
          isVerified: false,
        );

  final String uid;
  final String name;
  final String email;
  final DateTime dateCreated;
  final String? profilePictureUrl;
  final bool isVerified;
  final int totalEntries;
  final SentimentSummary sentimentSummary;
  final MoodSummary moodSummary;
  final TagsFrequency tagsFrequency;

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        dateCreated,
        profilePictureUrl,
        isVerified,
        totalEntries,
        sentimentSummary,
        moodSummary,
        tagsFrequency,
      ];

  @override
  String toString() => '''
        UserEntity {
          uid: $uid,
          name: $name,
          email: $email,
          dateCreated: $dateCreated,
          profilePictureUrl: $profilePictureUrl,
          isVerified: $isVerified,
          totalEntries: $totalEntries,
          sentimentSummary: $sentimentSummary,
          moodSummary: $moodSummary,
          tagsFrequency: $tagsFrequency,
        }
      ''';
}

class SentimentSummary extends Equatable {
  const SentimentSummary({
    required this.positive,
    required this.neutral,
    required this.negative,
  });

  const SentimentSummary.empty()
      : this(
          positive: 0,
          neutral: 0,
          negative: 0,
        );

  final int positive;
  final int neutral;
  final int negative;

  @override
  List<Object?> get props => [
        positive,
        neutral,
        negative,
      ];

  @override
  String toString() => '''
         {
          positive: $positive,
          neutral: $neutral,
          negative: $negative,
        }
      ''';
}

class MoodSummary extends Equatable {
  const MoodSummary({
    required this.happy,
    required this.neutral,
    required this.sad,
    required this.angry,
  });

  const MoodSummary.empty()
      : this(
          happy: 0,
          neutral: 0,
          sad: 0,
          angry: 0,
        );

  final int happy;
  final int neutral;
  final int sad;
  final int angry;

  @override
  List<Object?> get props => [
        happy,
        neutral,
        sad,
        angry,
      ];

  @override
  String toString() => '''
         {
          happy: $happy,
          neutral: $neutral,
          sad: $sad,
          angry: $angry,
        }
      ''';
}

class TagsFrequency extends Equatable {
  const TagsFrequency({
    required this.tags,
  });

  TagsFrequency.empty() : this(tags: {});
  final Map<String, int> tags;

  List<String> getTopTags({int n = 3}) {
    final sortedTags = tags.entries.toList()
      ..sort(
        (a, b) => b.value.compareTo(a.value),
      );
    return sortedTags.take(n).map((e) => e.key).toList();
  }

  /// Add or increment a tag's frequency
  TagsFrequency addTag(String tag) {
    final newTags = Map<String, int>.from(tags);
    newTags[tag] = (newTags[tag] ?? 0) + 1;
    return TagsFrequency(tags: newTags);
  }

  /// Add or increment a tag's frequency
  TagsFrequency addAllTags(List<String> tags) {
    final newTags = Map<String, int>.from(this.tags);
    for (final tag in tags) {
      newTags[tag] = (newTags[tag] ?? 0) + 1;
    }
    return TagsFrequency(tags: newTags);
  }

  /// Remove or decrement a tag's frequency
  TagsFrequency removeTag(String tag) {
    if (!tags.containsKey(tag)) return this;
    final newTags = Map<String, int>.from(tags);
    if (newTags[tag] == 1) {
      newTags.remove(tag);
    } else {
      newTags[tag] = newTags[tag]! - 1;
    }
    return TagsFrequency(tags: newTags);
  }

  @override
  List<Object?> get props => [tags];

  @override
  String toString() => tags.toString();
}
