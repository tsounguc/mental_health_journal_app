import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/notifications/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.scheduledTime,
  });

  NotificationModel.empty()
      : this(
          id: 1,
          title: '_empty.title',
          body: '_empty.body',
          scheduledTime: DateTime.now(),
        );

  NotificationModel.fromMap(DataMap map)
      : this(
          id: map['id'] as int? ?? 1,
          title: map['title'] as String? ?? '',
          body: map['body'] as String? ?? '{}',
          scheduledTime: map['dateCreated'] as DateTime? ?? DateTime.now(),
        );

  DataMap toMap() => {
        'id': id,
        'title': title,
        'body': body,
        'scheduledTime': scheduledTime,
      };

  NotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    DateTime? scheduledTime,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduledTime: scheduledTime ?? this.scheduledTime,
    );
  }
}
