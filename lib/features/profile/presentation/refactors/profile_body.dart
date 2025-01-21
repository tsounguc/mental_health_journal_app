import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/core/services/service_locator.dart';
import 'package:mental_health_journal_app/core/utils/core_utils.dart';
import 'package:mental_health_journal_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:mental_health_journal_app/features/profile/presentation/views/change_password_screen.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Stats',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colours.softGreyColor,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _statItem(
                      'Entries',
                      '50',
                    ),
                    const Divider(),
                    _statItem(
                      'Mood Trends',
                      'Positive: 60%, Neutral: 30%, Negative: 10%',
                    ),
                    const Divider(),
                    _statItem(
                      'Favority Tags',
                      '#gratitude #selfcare',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Settings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _settingsItem(
              context,
              'Change Password',
              Icons.lock,
            ),
            _settingsItem(
              context,
              'Notification Preferences',
              Icons.notifications,
            ),
            _settingsItem(
              context,
              'Privacy Policy',
              Icons.privacy_tip,
            ),
            _settingsItem(
              context,
              'Sign Out',
              Icons.logout,
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  CoreUtils.displayDeleteAccountWarning(
                    context,
                    onDeletePressed: () {
                      Navigator.pop(context);
                      CoreUtils.showEnterPasswordDialog(context);
                    },
                  );
                },
                child: Text(
                  'Delete Account',
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  // Helper Widget for Stats Items
  Widget _statItem(String title, String value) {
    var valueItems = <String>[];
    if (value.contains(',')) {
      valueItems = value.split(',');
    }
    return value.contains(',')
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Column(
                children: [
                  for (final item in valueItems)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colours.softGreyColor,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colours.softGreyColor,
                  ),
                ),
              ),
            ],
          );
  }

  Widget _settingsItem(BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        color: title == 'Sign Out' ? null : Colours.primaryColor,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      trailing: title == 'Sign Out' ? null : const Icon(Icons.keyboard_arrow_right),
      onTap: () async {
        // Handle settings item tap
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('$title tapped')),
        // );
        final navigator = Navigator.of(context);

        switch (title) {
          case 'Change Password':
            await navigator.pushNamed(
              ChangePasswordScreen.id,
              arguments: serviceLocator<AuthBloc>(),
            );
          case 'Notification Preferences':
            break;
          case 'Privacy Policy':
            break;
          case 'Sign Out':

            // context.read<AuthBloc>().add(
            //       const SignOutEvent(),
            //     );

            await serviceLocator<FirebaseAuth>().signOut();
            unawaited(
              navigator.pushNamedAndRemoveUntil(
                '/',
                (route) => false,
              ),
            );
        }
      },
    );
  }
}
