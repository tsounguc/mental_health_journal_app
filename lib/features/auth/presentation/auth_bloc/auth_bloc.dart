import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_journal_app/core/enums/update_user_action.dart';
import 'package:mental_health_journal_app/features/auth/domain/entities/user.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/create_user_account.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/delete_account.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/forgot_password.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/sign_in.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/sign_out.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/update_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required CreateUserAccount createUserAccount,
    required SignIn signIn,
    required SignOut signOut,
    required ForgotPassword forgotPassword,
    required DeleteAccount deleteAccount,
    required UpdateUser updateUser,
  })  : _createUserAccount = createUserAccount,
        _deleteAccount = deleteAccount,
        _forgotPassword = forgotPassword,
        _signIn = signIn,
        _signOut = signOut,
        _updateUser = updateUser,
        super(const AuthInitial()) {
    on<SignInEvent>(_signInHandler);
    on<SignUpEvent>(_signUpHandler);
    on<ForgotPasswordEvent>(_forgotPasswordHandler);
    on<DeleteAccountEvent>(_deleteAccountHandler);
    on<UpdateUserEvent>(_updateUserHandler);
    on<SignOutEvent>(_signOutHandler);
  }

  final SignIn _signIn;
  final SignOut _signOut;
  final CreateUserAccount _createUserAccount;
  final ForgotPassword _forgotPassword;
  final DeleteAccount _deleteAccount;
  final UpdateUser _updateUser;

  Future<void> _signInHandler(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _signIn(
      SignInParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(SignedIn(user: user)),
    );
  }

  Future<void> _signOutHandler(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signOut();

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (result) => emit(const SignedOut()),
    );
  }

  Future<void> _signUpHandler(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _createUserAccount(
      CreateUserAccountParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(SignedUp(user: user)),
    );
  }

  Future<void> _forgotPasswordHandler(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _forgotPassword(event.email);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (success) => emit(const ForgotPasswordSent()),
    );
  }

  Future<void> _deleteAccountHandler(
    DeleteAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _deleteAccount(event.password);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (success) => emit(const AccountDeleted()),
    );
  }

  Future<void> _updateUserHandler(
    UpdateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _updateUser(
      UpdateUserParams(
        action: event.action,
        userData: event.userData,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (success) => emit(const UserUpdated()),
    );
  }
}
