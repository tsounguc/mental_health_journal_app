part of 'notifications_cubit.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

final class NotificationsInitial extends NotificationsState {}

final class NotificationScheduling extends NotificationsState {
  const NotificationScheduling();
}

final class NotificationScheduled extends NotificationsState {
  const NotificationScheduled();
}

final class NotificationCanceling extends NotificationsState {
  const NotificationCanceling();
}

final class NotificationCanceled extends NotificationsState {
  const NotificationCanceled();
}

final class FetchingNotifications extends NotificationsState {
  const FetchingNotifications();
}

final class NotificationsFetched extends NotificationsState {
  const NotificationsFetched({required this.notifications});

  final List<NotificationEntity> notifications;

  @override
  List<Object> get props => [notifications];
}

final class NotificationsError extends NotificationsState {
  const NotificationsError({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [message];
}
