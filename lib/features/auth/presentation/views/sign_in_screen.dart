import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const id = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'SIGN UP SCREEN',
          style: context.theme.textTheme.bodyLarge,
        ),
      ),
    );
  }
}
