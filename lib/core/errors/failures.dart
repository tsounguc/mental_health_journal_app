import 'package:equatable/equatable.dart';
import 'package:mental_health_journal_app/core/errors/exceptions.dart';

abstract class Failure extends Equatable {
  Failure({
    required this.message,
    required this.statusCode,
  }) : assert(
          statusCode is String || statusCode is int,
          'StatusCode cannot be a ${statusCode.runtimeType}',
        );

  final String message;
  final dynamic statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class SignInFailure extends Failure {
  SignInFailure({
    required super.message,
    required super.statusCode,
  });

  SignInFailure.fromException(SignInException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );
}

class CreateUserAccountFailure extends Failure {
  CreateUserAccountFailure({
    required super.message,
    required super.statusCode,
  });

  CreateUserAccountFailure.fromException(CreateUserAccountException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );
}

class ForgotPasswordFailure extends Failure {
  ForgotPasswordFailure({
    required super.message,
    required super.statusCode,
  });

  ForgotPasswordFailure.fromException(ForgotPasswordException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );
}

class SignOutFailure extends Failure {
  SignOutFailure({
    required super.message,
    required super.statusCode,
  });

  SignOutFailure.fromException(SignOutException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );
}

class UpdateUserFailure extends Failure {
  UpdateUserFailure({
    required super.message,
    required super.statusCode,
  });

  UpdateUserFailure.fromException(UpdateUserException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );
}

class DeleteAccountFailure extends Failure {
  DeleteAccountFailure({
    required super.message,
    required super.statusCode,
  });

  DeleteAccountFailure.fromException(DeleteAccountException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );
}

class CreateEntryFailure extends Failure {
  CreateEntryFailure({
    required super.message,
    required super.statusCode,
  });

  CreateEntryFailure.fromException(CreateEntryException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );
}

class UpdateEntryFailure extends Failure {
  UpdateEntryFailure({
    required super.message,
    required super.statusCode,
  });

  UpdateEntryFailure.fromException(UpdateEntryException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );
}

class DeleteEntryFailure extends Failure {
  DeleteEntryFailure({
    required super.message,
    required super.statusCode,
  });

  DeleteEntryFailure.fromException(DeleteEntryException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );
}

class GetEntriesFailure extends Failure {
  GetEntriesFailure({
    required super.message,
    required super.statusCode,
  });

  GetEntriesFailure.fromException(GetEntriesException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );
}

class GetDashboardDataFailure extends Failure {
  GetDashboardDataFailure({
    required super.message,
    required super.statusCode,
  });

  GetDashboardDataFailure.fromException(GetDashboardDataException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );
}

class SearchEntriesFailure extends Failure {
  SearchEntriesFailure({
    required super.message,
    required super.statusCode,
  });

  SearchEntriesFailure.fromException(SearchEntriesException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );
}

class ScheduleNotificationFailure extends Failure {
  ScheduleNotificationFailure({
    required super.message,
    required super.statusCode,
  });

  ScheduleNotificationFailure.fromException(ScheduleNotificationException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );
}

class CancelNotificationFailure extends Failure {
  CancelNotificationFailure({
    required super.message,
    required super.statusCode,
  });

  CancelNotificationFailure.fromException(CancelNotificationException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );
}

class GetScheduledNotificationsFailure extends Failure {
  GetScheduledNotificationsFailure({
    required super.message,
    required super.statusCode,
  });

  GetScheduledNotificationsFailure.fromException(GetScheduledNotificationsException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );
}
