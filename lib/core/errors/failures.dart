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
  List<Object> get props => [message, statusCode];
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
