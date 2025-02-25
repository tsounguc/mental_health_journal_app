import 'package:mental_health_journal_app/core/use_case.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/notifications/domain/repositories/notification_repository.dart';

class CancelNotification implements UseCaseWithParams<void, int> {
  CancelNotification(this._repository);

  final NotificationRepository _repository;

  @override
  ResultVoid call(int params) => _repository.cancelNotification(params);
}
