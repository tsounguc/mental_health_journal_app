import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/common/widgets/i_field.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/core/resources/strings.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    this.onPasswordFieldSubmitted,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final void Function(String)? onPasswordFieldSubmitted;
  final GlobalKey<FormState> formKey;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    const visible = Icons.visibility_outlined;
    const invisible = Icons.visibility_off_outlined;
    final icon = obscurePassword ? visible : invisible;
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          IField(
            controller: widget.emailController,
            hintText: Strings.emailHintText,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 25),
          IField(
            controller: widget.passwordController,
            hintText: Strings.passwordHintText,
            obscureText: obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.send,
            onFieldSubmitted: widget.onPasswordFieldSubmitted,
            suffixIcon: IconButton(
              onPressed: () => setState(() {
                obscurePassword = !obscurePassword;
              }),
              icon: Icon(
                icon,
                color: Colours.softGreyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
