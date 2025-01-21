import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_journal_app/core/common/views/long_button.dart';
import 'package:mental_health_journal_app/core/enums/update_user_action.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/utils/core_utils.dart';
import 'package:mental_health_journal_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:mental_health_journal_app/features/profile/presentation/widget/change_password_form.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  static const String id = '/change-password';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final passwordController = TextEditingController();
  final oldPasswordController = TextEditingController();

  bool get passwordChanged => passwordController.text.trim().isNotEmpty;

  bool get nothingChanged => !passwordChanged;

  void saveChanges(BuildContext context) {
    if (nothingChanged) Navigator.pop(context);
    final bloc = context.read<AuthBloc>();
    if (passwordChanged) {
      if (oldPasswordController.text.isEmpty) {
        CoreUtils.showSnackBar(
          context,
          'Please enter your old password',
        );
        return;
      }
      bloc.add(
        UpdateUserEvent(
          action: UpdateUserAction.password,
          userData: jsonEncode({
            'oldPassword': oldPasswordController.text.trim(),
            'newPassword': passwordController.text.trim(),
          }),
        ),
      );
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    oldPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UserUpdated) {
          Navigator.of(context).pop();
          CoreUtils.showSnackBar(
            context,
            'Password changed successfully',
          );
        } else if (state is AuthError) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            surfaceTintColor: context.theme.scaffoldBackgroundColor,
            title: const Text('Change Password'),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            children: [
              ChangePasswordForm(
                oldPasswordController: oldPasswordController,
                passwordController: passwordController,
                onPasswordFieldSubmitted: (_) => saveChanges(context),
              ),
              const SizedBox(height: 30),
              StatefulBuilder(
                builder: (context, refresh) {
                  passwordController.addListener(() => refresh(() {}));
                  return state is AuthLoading
                      ? const Center(child: CircularProgressIndicator())
                      : LongButton(
                          onPressed: nothingChanged
                              ? null
                              : () => saveChanges(
                                    context,
                                  ),
                          label: 'Submit',
                        );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
