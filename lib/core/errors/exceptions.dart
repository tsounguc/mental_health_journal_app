import 'package:equatable/equatable.dart';

class SignInException extends Equatable implements Exception {
  const SignInException({
    required this.message,
    required this.statusCode,
  });
  final String message;
  final String statusCode;

  @override
  List<Object> get props => [message, statusCode];
}

class CreateUserAccountException extends Equatable implements Exception {
  const CreateUserAccountException({
    required this.message,
    required this.statusCode,
  });
  final String message;
  final String statusCode;

  @override
  List<Object> get props => [message, statusCode];
}

class ForgotPasswordException extends Equatable implements Exception {
  const ForgotPasswordException({
    required this.message,
    required this.statusCode,
  });
  final String message;
  final String statusCode;

  @override
  List<Object> get props => [message, statusCode];
}

class SignOutException extends Equatable implements Exception {
  const SignOutException({
    required this.message,
    required this.statusCode,
  });
  final String message;
  final String statusCode;

  @override
  List<Object> get props => [message, statusCode];
}

class UpdateUserException extends Equatable implements Exception {
  const UpdateUserException({
    required this.message,
    required this.statusCode,
  });
  final String message;
  final String statusCode;

  @override
  List<Object> get props => [message, statusCode];
}

class DeleteAccountException extends Equatable implements Exception {
  const DeleteAccountException({
    required this.message,
    required this.statusCode,
  });
  final String message;
  final String statusCode;

  @override
  List<Object> get props => [message, statusCode];
}
