import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static const id = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'DASHBOARD SCREEN',
              style: context.theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 25),
            TextButton(
              onPressed: () {

              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
