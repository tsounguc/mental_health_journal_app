import 'package:flutter/cupertino.dart';
import 'package:mental_health_journal_app/core/services/notifications_service/notifications_service.dart';
import 'package:mental_health_journal_app/core/services/service_locator.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  debugPrint('✅ callbackDispatcher TRIGGERED!');
  Workmanager().executeTask((task, inputData) async {
    debugPrint('WorkManager Task Triggered: $task');
    debugPrint('Input Data: $inputData');

    WidgetsFlutterBinding.ensureInitialized();

    final notificationService = NotificationsService();

    debugPrint('✅ Calling showInstantNotification...');
    await notificationService.showInstantNotification(
      id: inputData?['id'] as int,
      title: inputData?['title'] as String,
      body: inputData?['body'] as String,
    );
    debugPrint('✅ Notification Triggered Successfully!');

    return Future.value(true);
  });
}

class NotificationUtils {
  const NotificationUtils._();

  /// **🔹 Schedule Background Task Instead of `zonedSchedule()`**
  static Future<void> scheduleJournalReminder({
    required int id,
    required String title,
    required String body,
    Duration? initialDelay,
  }) async {
    debugPrint('scheduleJournalReminder');
    await Workmanager().registerPeriodicTask(
      'journal_reminder_task',
      'journal_reminder',
      frequency: const Duration(days: 1), // Adjust timing as needed
      initialDelay: initialDelay ?? const Duration(seconds: 5),
      inputData: {'id': id, 'title': title, 'body': body},
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
      ),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  /// **🔹 Cancel Background Task**
  static Future<void> cancelJournalReminder() async {
    await Workmanager().cancelByUniqueName('journal_reminder_task');
  }
}
