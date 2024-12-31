import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/auth/domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.dateCreated,
    required super.profilePictureUrl,
    required super.isVerified,
  });

  UserModel.empty()
      : this(
          uid: '_empty.uid',
          name: '_empty.name',
          email: '_empty.email',
          dateCreated: const DateCreatedModel.empty(),
          profilePictureUrl: '_empty.profilePictureUrl',
          isVerified: false,
        );

  factory UserModel.fromJson(String source) => UserModel.fromMap(
        jsonDecode(source) as DataMap,
      );

  DataMap toMap() => {
        'uid': uid,
        'name': name,
        'email': email,
        'dateCreated': (dateCreated as DateCreatedModel).toMap(),
        'profilePictureUrl': profilePictureUrl,
        'isVerified': isVerified
      };

  UserModel.fromMap(DataMap map)
      : this(
          uid: map['uid'] == null ? '' : map['uid'] as String,
          name: map['name'] == null ? '' : map['name'] as String,
          email: map['email'] == null ? '' : map['email'] as String,
          dateCreated: map['dateCreated'] == null
              ? const DateCreatedModel.empty()
              : DateCreatedModel.fromMap(map['dateCreated'] as DataMap),
          // dateCreated: (map['dateCreated'] as Timestamp).toDate(),
          profilePictureUrl: map['profilePictureUrl'] == null ? '' : map['profilePictureUrl'] as String,
          isVerified: map['isVerified'] as bool,
        );

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    DateCreatedModel? dateCreated,
    String? profilePictureUrl,
    bool? isVerified,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      dateCreated: dateCreated ?? this.dateCreated,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

class DateCreatedModel extends DateCreated {
  const DateCreatedModel({
    required super.seconds,
    required super.nanoseconds,
  });

  const DateCreatedModel.empty()
      : this(
          seconds: 0,
          nanoseconds: 0,
        );

  DateCreatedModel.fromMap(DataMap map)
      : this(
          seconds: map['_seconds'] as int,
          nanoseconds: map['_nanoseconds'] as int,
        );
  DataMap toMap() => {"_seconds": seconds, "_nanoseconds": nanoseconds};
}
