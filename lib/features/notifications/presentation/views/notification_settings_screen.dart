import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_journal_app/core/utils/core_utils.dart';
import 'package:mental_health_journal_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:mental_health_journal_app/features/notifications/presentation/notifications_cubit/notifications_cubit.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  static const id = '/notification-settings';

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool isNotificationEnabled = false;
  TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);

  Future<void> _selectReminderTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void _saveNotificationSettings(BuildContext context) {
    if (isNotificationEnabled) {
      final now = DateTime.now();
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      final notification = NotificationEntity(
        id: 1,
        title: 'Time to Journal!',
        body: "Don't forget to log your thoughts today.",
        scheduledTime: scheduledTime,
      );

      context.read<NotificationsCubit>().scheduleNotification(notification: notification);
    } else {
      context.read<NotificationsCubit>().cancelNotification(id: 1);
    }
  }

  void _toggleNotificationSettings(bool value, BuildContext context) {
    setState(() {
      isNotificationEnabled = value;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().getScheduledNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: (context, state) {
        if (state is NotificationSettingsLoaded) {
          setState(() {
            isNotificationEnabled = state.isEnabled;
            selectedTime = TimeOfDay(
              hour: state.scheduledTime.hour,
              minute: state.scheduledTime.minute,
            );
          });
        } else if (state is NotificationCanceled || state is NotificationScheduled) {
          CoreUtils.showSnackBar(context, 'Settings Saved');
          Navigator.of(context).pop();
        } else if (state is NotificationsError) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Notification Settings')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Enable Notifications'),
                  value: isNotificationEnabled,
                  onChanged: (value) => _toggleNotificationSettings(
                    value,
                    context,
                  ),
                ),
                ListTile(
                  title: const Text('Reminder Time'),
                  subtitle: Text(selectedTime.format(context)),
                  onTap: !isNotificationEnabled ? null : () async => _selectReminderTime(context),
                ),
                ElevatedButton(
                  onPressed: () => _saveNotificationSettings(context),
                  child: const Text('Save Settings'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
