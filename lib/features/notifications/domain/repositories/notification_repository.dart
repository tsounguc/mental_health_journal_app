import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  const NotificationRepository();

  ResultVoid scheduleNotification(NotificationEntity notification);

  ResultVoid cancelNotification(int id);

  ResultFuture<List<NotificationEntity>> getScheduledNotifications();
}
