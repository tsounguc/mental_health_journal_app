import 'package:mental_health_journal_app/core/use_case.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:mental_health_journal_app/features/notifications/domain/repositories/notification_repository.dart';

class ScheduleNotification implements UseCaseWithParams<void, NotificationEntity> {
  ScheduleNotification(this._repository);

  final NotificationRepository _repository;

  @override
  ResultVoid call(
    NotificationEntity params,
  ) =>
      _repository.scheduleNotification(params);
}
