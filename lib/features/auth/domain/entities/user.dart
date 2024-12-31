import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.dateCreated,
    required this.profilePictureUrl,
    required this.isVerified,
  });

  const UserEntity.empty()
      : this(
          uid: '',
          name: '',
          email: '',
          dateCreated: const DateCreated.empty(),
          profilePictureUrl: '',
          isVerified: false,
        );

  final String uid;
  final String name;
  final String email;
  final DateCreated dateCreated;
  final String? profilePictureUrl;
  final bool isVerified;

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        // dateCreated,
        profilePictureUrl,
        isVerified,
      ];

  @override
  String toString() => 'UserEntity { \nuid: $uid, \nname: $name, '
      '\nemail: $email, \ndateCreated: $dateCreated, '
      '\nprofilePictureUrl: $profilePictureUrl \nisVerified: $isVerified, '
      '\n}';
}

class DateCreated extends Equatable {
  const DateCreated({
    required this.seconds,
    required this.nanoseconds,
  });

  const DateCreated.empty()
      : this(
          seconds: 0,
          nanoseconds: 0,
        );
  final int seconds;
  final int nanoseconds;

  @override
  List<Object?> get props => [seconds, nanoseconds];

  @override
  String toString() => '{ \nseconds: $seconds, \nnanoseconds: $nanoseconds, '
      '\n}';
}
