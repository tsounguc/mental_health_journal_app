import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_journal_app/core/common/widgets/time_text.dart';
import 'package:mental_health_journal_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:mental_health_journal_app/features/notifications/presentation/notifications_cubit/notifications_cubit.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile(this.notification, {super.key});

  final NotificationEntity notification;

  @override
  Widget build(BuildContext context) {
    // if (!notification.seen) {
    //   context.read<NotificationsCubit>().markAsRead(notification.id);
    // }
    return Dismissible(
      key: Key(notification.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        context.read<NotificationsCubit>().cancelNotification(id: notification.id);
      },
      child: ListTile(
        title: Text(
          notification.title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        subtitle: TimeText(notification.scheduledTime),
      ),
    );
  }
}
