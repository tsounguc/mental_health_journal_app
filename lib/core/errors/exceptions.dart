import 'package:equatable/equatable.dart';

class SignInWithEmailException extends Equatable implements Exception {
  const SignInWithEmailException({
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
