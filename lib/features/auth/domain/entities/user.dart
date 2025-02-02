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
    required this.topTags,
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
          topTags: [],
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
  final List<String> topTags;

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
        topTags,
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
          topTags: $topTags,
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
