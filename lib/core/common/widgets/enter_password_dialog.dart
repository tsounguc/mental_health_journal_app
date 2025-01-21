import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_journal_app/core/common/widgets/i_field.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/utils/core_utils.dart';
import 'package:mental_health_journal_app/features/auth/presentation/auth_bloc/auth_bloc.dart';

class EnterPasswordDialog extends StatefulWidget {
  const EnterPasswordDialog({super.key});

  @override
  State<EnterPasswordDialog> createState() => _EnterPasswordDialogState();
}

class _EnterPasswordDialogState extends State<EnterPasswordDialog> {
  final textController = TextEditingController();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (_, state) {
        if (state is AccountDeleted) {
          Navigator.of(context).pop();
          CoreUtils.showSnackBar(context, 'Account deleted', durationInMilliSecond: 1500);
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/',
            (route) => false,
          );
        }
        if (state is AuthError) {
          Navigator.of(context).pop();
          debugPrint(state.message);
          CoreUtils.showSnackBar(context, state.message, durationInMilliSecond: 2000);
        }
        if (state is AuthLoading) {
          CoreUtils.showLoadingDialog(context);
        }
      },
      child: AlertDialog(
        // backgroundColor: Colors.yellow[600],
        backgroundColor: context.theme.cardTheme.color,
        surfaceTintColor: context.theme.cardTheme.color,
        title: Text(
          'Enter Password',
          style: context.theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        content: IField(
          controller: textController,
          hintText: 'Enter Password',
          obscureText: obscurePassword,
          keyboardType: TextInputType.visiblePassword,
          suffixIcon: IconButton(
            onPressed: () => setState(() {
              obscurePassword = !obscurePassword;
            }),
            icon: Icon(
              obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: Colors.grey,
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'CANCEL',
              style: context.theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              'DELETE ACCOUNT',
              style: context.theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.red,
              ),
            ),
            onPressed: () {
              bloc.add(
                DeleteAccountEvent(
                  password: textController.text.trim(),
                ),
              );
              context.userProvider.user = null;
            },
          ),
        ],
      ),
    );
  }
}
