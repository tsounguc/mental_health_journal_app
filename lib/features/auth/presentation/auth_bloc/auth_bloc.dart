import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mental_health_journal_app/core/enums/update_user_action.dart';
import 'package:mental_health_journal_app/features/auth/domain/entities/user.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/create_user_account.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/delete_account.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/sign_in.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/update_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignIn signIn,
    required CreateUserAccount createUserAccount,
    required ForgotPassword forgotPassword,
    required DeleteAccount deleteAccount,
    required UpdateUser updateUser,
  })  : _signIn = signIn,
        _createUserAccount = createUserAccount,
        _forgotPassword = forgotPassword,
        _deleteAccount = deleteAccount,
        _updateUser = updateUser,
        super(const AuthInitial()) {
    on<AuthEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  final SignIn _signIn;
  final CreateUserAccount _createUserAccount;
  final ForgotPassword _forgotPassword;
  final DeleteAccount _deleteAccount;
  final UpdateUser _updateUser;
}
