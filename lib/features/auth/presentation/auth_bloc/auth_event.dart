part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpEvent extends AuthEvent {
  const SignUpEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;

  @override
  List<Object> get props => [name, email, password];
}

class DeleteAccountEvent extends AuthEvent {
  const DeleteAccountEvent({
    required this.password,
  });

  final String password;

  @override
  List<Object> get props => [password];
}

class ForgotPassword extends AuthEvent {
  const ForgotPassword({
    required this.email,
  });

  final String email;

  @override
  List<Object> get props => [email];
}

class SignInEvent extends AuthEvent {
  const SignInEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class UpdateUserEvent extends AuthEvent {
  UpdateUserEvent({
    required this.action,
    required this.userData,
  }) : assert(
          userData is String || userData is File,
          '[userData] must be either a String or File, '
          'but was ${userData.runtimeType}',
        );

  final UpdateUserAction action;
  final dynamic userData;

  @override
  List<Object> get props => [action, userData];
}
