import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.dateCreated,
    required this.isVerified,
    this.profilePictureUrl,
  });

  UserEntity.empty()
      : this(
          uid: '',
          name: '',
          email: '',
          dateCreated: DateTime.now(),
          profilePictureUrl: '',
          isVerified: false,
        );

  final String uid;
  final String name;
  final String email;
  final DateTime dateCreated;
  final String? profilePictureUrl;
  final bool isVerified;

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        dateCreated,
        profilePictureUrl,
        isVerified,
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
        }
      ''';
}
