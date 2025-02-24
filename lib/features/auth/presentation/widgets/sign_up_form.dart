import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/common/widgets/i_field.dart';
import 'package:mental_health_journal_app/core/resources/strings.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    this.onConfirmPasswordFieldSubmitted,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final void Function(String)? onConfirmPasswordFieldSubmitted;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    const visible = Icons.visibility_outlined;
    const invisible = Icons.visibility_off_outlined;
    final icon = obscurePassword ? visible : invisible;
    final confirmIcon = obscureConfirmPassword ? visible : invisible;
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          IField(
            controller: widget.nameController,
            hintText: Strings.nameHintText,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 25),
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
            suffixIcon: IconButton(
              icon: Icon(
                icon,
                color: Colors.grey,
              ),
              onPressed: () => setState(() {
                obscurePassword = !obscurePassword;
              }),
            ),
          ),
          const SizedBox(height: 25),
          IField(
            controller: widget.confirmPasswordController,
            hintText: Strings.confirmPasswordHintText,
            obscureText: obscureConfirmPassword,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.send,
            onFieldSubmitted: widget.onConfirmPasswordFieldSubmitted,
            suffixIcon: IconButton(
              onPressed: () => setState(() {
                obscureConfirmPassword = !obscureConfirmPassword;
              }),
              icon: Icon(
                confirmIcon,
                color: Colors.grey,
              ),
            ),
            overrideValidator: true,
            validator: (value) {
              if (value != widget.passwordController.text) {
                return Strings.passwordValidatorText;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
