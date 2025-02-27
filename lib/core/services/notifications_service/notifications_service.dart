import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsService {
  NotificationsService() {
    _initNotification();
  }

  final _notificationPlugin = FlutterLocalNotificationsPlugin();

  var _initialized = false;

  bool get isInitialized => _initialized;
  Future<void> _initNotification() async {
    if (_initialized) return;

    tz.initializeTimeZones();
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
    await _notificationPlugin.initialize(initSettings);
    _initialized = true;
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

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime date,
  }) {
    final details = _notificationDetails();
    final scheduledDate = tz.TZDateTime.from(
      date,
      tz.local,
    );
    return _notificationPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelNotification(int id) async {
    return _notificationPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() {
    return _notificationPlugin.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getScheduledNotifications() async {
    return _notificationPlugin.pendingNotificationRequests();
  }
}
