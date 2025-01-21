import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/features/profile/presentation/widget/change_password_form_field.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({
    required this.passwordController,
    required this.oldPasswordController,
    required this.onPasswordFieldSubmitted,
    super.key,
  });

  final TextEditingController passwordController;
  final TextEditingController oldPasswordController;
  final void Function(String)? onPasswordFieldSubmitted;

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChangePasswordFormField(
          fieldTitle: 'Current Password',
          controller: widget.oldPasswordController,
          hintText: '********',
          textInputAction: TextInputAction.next,
        ),
        StatefulBuilder(
          builder: (_, setState) {
            widget.oldPasswordController.addListener(
              () => setState(() {}),
            );
            return ChangePasswordFormField(
              fieldTitle: 'New Password',
              controller: widget.passwordController,
              hintText: '********',
              readOnly: widget.oldPasswordController.text.isEmpty,
              onFieldSubmitted: widget.onPasswordFieldSubmitted,
            );
          },
        ),
      ],
    );
  }
}
