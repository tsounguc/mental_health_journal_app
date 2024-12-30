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

  SignInFailure.fromException(SignInWithEmailException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );
}