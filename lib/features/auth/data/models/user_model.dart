import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/auth/domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.dateCreated,
    required super.totalEntries,
    required super.sentimentSummary,
    required super.moodSummary,
    required super.topTags,
    required super.isVerified,
    super.profilePictureUrl,
  });

  UserModel.empty()
      : this(
          uid: '_empty.uid',
          name: '_empty.name',
          email: '_empty.email',
          dateCreated: DateTime.now(),
          totalEntries: 0,
          sentimentSummary: const SentimentSummaryModel.empty(),
          moodSummary: const MoodSummaryModel.empty(),
          topTags: [],
          profilePictureUrl: null,
          isVerified: false,
        );

  UserModel.fromMap(DataMap map)
      : this(
          uid: map['uid'] as String? ?? '',
          name: map['name'] as String? ?? '',
          email: map['email'] as String? ?? '',
          dateCreated: (map['dateCreated'] as Timestamp?)?.toDate() ?? DateTime.now(),
          totalEntries: map['totalEntries'] as int? ?? 0,
          sentimentSummary: map['sentimentSummary'] == null
              ? const SentimentSummaryModel.empty()
              : SentimentSummaryModel.fromMap(
                  map['sentimentSummary'] as DataMap,
                ),
          moodSummary: map['sentimentSummary'] == null
              ? const MoodSummaryModel.empty()
              : MoodSummaryModel.fromMap(map['moodSummary'] as DataMap),
          topTags: map['topTags'] != null ? List<String>.from(map['topTags'] as List) : [],
          profilePictureUrl: map['profilePictureUrl'] as String?,
          isVerified: map['isVerified'] as bool? ?? false,
        );

  DataMap toMap() => {
        'uid': uid,
        'name': name,
        'email': email,
        'dateCreated': Timestamp.fromDate(dateCreated),
        'totalEntries': totalEntries,
        'sentimentSummary': (sentimentSummary as SentimentSummaryModel).toMap(),
        'moodSummary': (moodSummary as MoodSummaryModel).toMap(),
        'topTags': topTags,
        'profilePictureUrl': profilePictureUrl,
        'isVerified': isVerified,
      };

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    DateTime? dateCreated,
    int? totalEntries,
    SentimentSummaryModel? sentimentSummary,
    MoodSummaryModel? moodSummary,
    List<String>? topTags,
    String? profilePictureUrl,
    bool? isVerified,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      dateCreated: dateCreated ?? this.dateCreated,
      totalEntries: totalEntries ?? this.totalEntries,
      sentimentSummary: sentimentSummary ?? this.sentimentSummary,
      moodSummary: moodSummary ?? this.moodSummary,
      topTags: topTags ?? this.topTags,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

class SentimentSummaryModel extends SentimentSummary {
  const SentimentSummaryModel({
    required super.positive,
    required super.neutral,
    required super.negative,
  });

  const SentimentSummaryModel.empty()
      : this(
          positive: 0,
          neutral: 0,
          negative: 0,
        );

  SentimentSummaryModel.fromMap(DataMap map)
      : this(
          positive: map['positive'] as int? ?? 0,
          neutral: map['neutral'] as int? ?? 0,
          negative: map['negative'] as int? ?? 0,
        );

  DataMap toMap() => {
        'positive': positive,
        'neutral': neutral,
        'negative': negative,
      };

  SentimentSummaryModel copyWith({
    int? positive,
    int? neutral,
    int? negative,
  }) {
    return SentimentSummaryModel(
      positive: positive ?? this.positive,
      neutral: neutral ?? this.neutral,
      negative: negative ?? this.negative,
    );
  }
}

class MoodSummaryModel extends MoodSummary {
  const MoodSummaryModel({
    required super.happy,
    required super.neutral,
    required super.sad,
    required super.angry,
  });

  const MoodSummaryModel.empty()
      : this(
          happy: 0,
          neutral: 0,
          sad: 0,
          angry: 0,
        );

  MoodSummaryModel.fromMap(DataMap map)
      : this(
          happy: map['happy'] as int? ?? 0,
          neutral: map['neutral'] as int? ?? 0,
          sad: map['sad'] as int? ?? 0,
          angry: map['angry'] as int? ?? 0,
        );

  DataMap toMap() => {
        'happy': happy,
        'neutral': neutral,
        'sad': sad,
        'angry': angry,
      };

  MoodSummaryModel copyWith({
    int? happy,
    int? neutral,
    int? sad,
    int? angry,
  }) {
    return MoodSummaryModel(
      happy: happy ?? this.happy,
      neutral: neutral ?? this.neutral,
      sad: sad ?? this.sad,
      angry: angry ?? this.angry,
    );
  }
}
