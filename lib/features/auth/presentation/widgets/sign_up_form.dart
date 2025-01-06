import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/common/views/i_field.dart';

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
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          IField(
            controller: widget.nameController,
            hintText: 'Name',
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 25),
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
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              ),
              onPressed: () => setState(() {
                obscurePassword = !obscurePassword;
              }),
            ),
          ),
          const SizedBox(height: 25),
          IField(
            controller: widget.confirmPasswordController,
            hintText: 'Confirm Password',
            obscureText: obscureConfirmPassword,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.send,
            onFieldSubmitted: widget.onConfirmPasswordFieldSubmitted,
            suffixIcon: IconButton(
              onPressed: () => setState(() {
                obscureConfirmPassword = !obscureConfirmPassword;
              }),
              icon: Icon(
                obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.grey,
              ),
            ),
            overrideValidator: true,
            validator: (value) {
              if (value != widget.passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
