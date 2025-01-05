import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const id = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'SIGN IN SCREEN',
          style: context.theme.textTheme.bodyLarge,
        ),
      ),
    );
  }
}
