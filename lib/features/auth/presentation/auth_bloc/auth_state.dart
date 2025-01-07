part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthError extends AuthState {
  const AuthError({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [message];
}

final class SignedIn extends AuthState {
  const SignedIn({
    required this.user,
  });

  final UserEntity user;

  @override
  List<Object> get props => [user];
}

final class SignedOut extends AuthState {
  const SignedOut();
}

final class SignedUp extends AuthState {
  const SignedUp({required this.user});

  final UserEntity user;

  @override
  List<Object> get props => [user];
}

final class ForgotPasswordSent extends AuthState {
  const ForgotPasswordSent();
}

final class UserUpdated extends AuthState {
  const UserUpdated();
}

final class AccountDeleted extends AuthState {
  const AccountDeleted();
}
