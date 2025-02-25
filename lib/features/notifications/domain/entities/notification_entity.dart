import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
  });

  NotificationEntity.empty()
      : this(
          id: 1,
          title: '',
          body: '',
          scheduledTime: DateTime.now(),
        );

  final int id;
  final String title;
  final String body;
  final DateTime scheduledTime;

  @override
  List<Object?> get props => [id, title, body, scheduledTime];
}
