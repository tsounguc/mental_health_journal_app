import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mental_health_journal_app/core/errors/exceptions.dart';
import 'package:mental_health_journal_app/core/services/notifications_service/notifications_service.dart';
import 'package:mental_health_journal_app/features/notifications/data/models/notification_model.dart';
import 'package:mental_health_journal_app/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationLocalDataSource {
  const NotificationLocalDataSource();

  Future<void> scheduleNotification(NotificationEntity notification);

  Future<void> cancelNotification(int id);

  Future<List<NotificationModel>> getScheduledNotifications();
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  NotificationLocalDataSourceImpl({
    required NotificationsService notificationPlugin,
  }) : _notificationPlugin = notificationPlugin;

  final NotificationsService _notificationPlugin;

  @override
  Future<void> cancelNotification(int id) async {
    try {
      if (id < 0) {
        throw CancelNotificationException(
          message: 'Invalid notification ID: $id',
          statusCode: 'INVALID_ID',
        );
      }
      await _notificationPlugin.cancelNotification(id);
    } on PlatformException catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
      throw CancelNotificationException(
        message: 'Failed to cancel notification: ${e.message}',
        statusCode: 'PLATFORM_ERROR',
      );
    } on MissingPluginException catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
      throw CancelNotificationException(
        message: 'Notification plugin not initialized: ${e.message}',
        statusCode: 'PLUGIN_MISSING',
      );
    } catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
      throw CancelNotificationException(
        message: 'Unexpected error while canceling notification: $e',
        statusCode: 'UNKNOWN_ERROR',
      );
    }
  }

  @override
  Future<List<NotificationModel>> getScheduledNotifications() async {
    try {
      final notifications = await _notificationPlugin.getScheduledNotifications();

      return notifications
          .map(
            (notification) => NotificationModel(
              id: notification.id,
              title: notification.title ?? '',
              body: notification.body ?? '',
              scheduledTime: DateTime.now(),
            ),
          )
          .toList();
    } on PlatformException catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
      throw GetScheduledNotificationsException(
        message: e.message ?? 'Failed to retrieve scheduled notifications',
        statusCode: e.code,
      );
    } on MissingPluginException catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
      throw const GetScheduledNotificationsException(
        message: 'Notification plugin not initialized',
        statusCode: 'PLUGIN_NOT_INITIALIZED',
      );
    } catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
      throw GetScheduledNotificationsException(
        message: e.toString(),
        statusCode: 'UNKNOWN_ERROR',
      );
    }
  }

  @override
  Future<void> scheduleNotification(NotificationEntity notification) async {
    try {
      await _notificationPlugin.scheduleNotification(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        date: notification.scheduledTime,
      );
    } on PlatformException catch (e) {
      throw ScheduleNotificationException(
        message: 'Failed to schedule notification: ${e.message}',
        statusCode: 'PLATFORM_ERROR',
      );
    } on MissingPluginException catch (e) {
      throw ScheduleNotificationException(
        message: 'Notification plugin not initialized: ${e.message}',
        statusCode: 'PLUGIN_MISSING',
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      debugPrint(e.toString());
      throw ScheduleNotificationException(
        message: 'Unexpected error while scheduling notification: $e',
        statusCode: 'UNKNOWN_ERROR',
      );
    }
  }
}
