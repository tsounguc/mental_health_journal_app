import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/common/views/i_field.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';

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
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          IField(
            controller: widget.emailController,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 25),
          IField(
            controller: widget.passwordController,
            hintText: 'Password',
            obscureText: obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.send,
            onFieldSubmitted: widget.onPasswordFieldSubmitted,
            suffixIcon: IconButton(
              onPressed: () => setState(() {
                obscurePassword = !obscurePassword;
              }),
              icon: Icon(obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: Colours.softGreyColor),
            ),
          )
        ],
      ),
    );
  }
}
