import 'package:dartz/dartz.dart';
import 'package:mental_health_journal_app/core/errors/exceptions.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/notifications/data/data_sources/notification_local_data_source.dart';
import 'package:mental_health_journal_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:mental_health_journal_app/features/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._localDataSource);

  final NotificationLocalDataSource _localDataSource;

  @override
  ResultVoid cancelNotification(int id) async {
    try {
      final result = await _localDataSource.cancelNotification(id);
      return Right(result);
    } on CancelNotificationException catch (e) {
      return Left(CancelNotificationFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<NotificationEntity>> getScheduledNotifications() async {
    try {
      final result = await _localDataSource.getScheduledNotifications();
      return Right(result);
    } on GetScheduledNotificationsException catch (e) {
      return Left(GetScheduledNotificationsFailure.fromException(e));
    }
  }

  @override
  ResultVoid scheduleNotification(NotificationEntity notification) async {
    try {
      final result = await _localDataSource.scheduleNotification(notification);
      return Right(result);
    } on ScheduleNotificationException catch (e) {
      return Left(ScheduleNotificationFailure.fromException(e));
    }
  }
}
