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
    required super.isVerified,
    super.profilePictureUrl,
  });

  UserModel.empty()
      : this(
          uid: '_empty.uid',
          name: '_empty.name',
          email: '_empty.email',
          dateCreated: DateTime.now(),
          profilePictureUrl: null,
          isVerified: false,
        );

  factory UserModel.fromJson(String source) => UserModel.fromMap(
        jsonDecode(source) as DataMap,
      );

  UserModel.fromMap(DataMap map)
      : this(
          uid: map['uid'] as String? ?? '',
          name: map['name'] as String? ?? '',
          email: map['email'] as String? ?? '',
          dateCreated: (map['dateCreated'] as Timestamp?)?.toDate() ?? DateTime.now(),
          profilePictureUrl: map['profilePictureUrl'] as String?,
          isVerified: map['isVerified'] as bool? ?? false,
        );

  DataMap toMap() => {
        'uid': uid,
        'name': name,
        'email': email,
        'dateCreated': FieldValue.serverTimestamp(),
        'profilePictureUrl': profilePictureUrl,
        'isVerified': isVerified,
      };

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    DateTime? dateCreated,
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
