import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:mental_health_journal_app/features/notifications/utils/notification_utils.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

class NotificationsService {
  NotificationsService() {
    _initNotification();
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  final _notificationPlugin = FlutterLocalNotificationsPlugin();

  var _initialized = false;

  bool get isInitialized => _initialized;

  Future<void> _initNotification() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    try {
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      final detectedLocation = tz.getLocation(timeZoneName);
      tz.setLocalLocation(detectedLocation);

      debugPrint('Detected device time zone: $timeZoneName');
    } catch (e) {
      debugPrint('Error detecting time zone: $e');
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
    // android init settings
    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    // ios init settings
    const initSettingsIOS = DarwinInitializationSettings();

    // init settings
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    // initialize plugin
    final initialized = await _notificationPlugin.initialize(initSettings);
    _initialized = initialized ?? false;
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'journal_channel',
        'Journal Reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  tz.TZDateTime _nextInstanceOfTime(DateTime time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      0,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    debugPrint('Current time: $now');
    debugPrint('Final scheduled notification time: $scheduledDate');

    return scheduledDate;
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime date,
  }) async {
    await _initNotification();

    final now = DateTime.now();
    debugPrint('🚀 Attempting to schedule notification...');
    debugPrint('⏰ Requested notification time: $date');
    if (date.isBefore(now)) {
      date = date.add(const Duration(days: 1));
    }
    debugPrint('📌 Final scheduled time (converted): $date');

    final scheduledTime = _nextInstanceOfTime(date);
    final initialDelay = scheduledTime.difference(now);
    debugPrint('initial delay: $initialDelay');

    await NotificationUtils.scheduleJournalReminder(
      initialDelay: initialDelay,
      id: id,
      title: title,
      body: body,
    );
  }

  Future<void> cancelNotification(int id) async {
    debugPrint('cancelNotification');
    await NotificationUtils.cancelJournalReminder();
    return _notificationPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await NotificationUtils.cancelJournalReminder();
    return _notificationPlugin.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getScheduledNotifications() async {
    return _notificationPlugin.pendingNotificationRequests();
  }

  /// **🔹 Show Instant Notification (Used in Workmanager)**
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    // await _initNotification();
    debugPrint('showInstantNotification');
    await _notificationPlugin.show(
      1,
      title,
      body,
      _notificationDetails(),
    );
  }
}
