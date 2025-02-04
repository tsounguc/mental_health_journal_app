import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/common/app/providers/user_provider.dart';
import 'package:mental_health_journal_app/core/common/widgets/section_header.dart';
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
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        final user = context.currentUser;
        final positive = user?.sentimentSummary.positive ?? 0;
        final negative = user?.sentimentSummary.negative ?? 0;
        final neutral = user?.sentimentSummary.neutral ?? 0;
        final total = user?.totalEntries ?? 0;
        final posPct = total == 0 ? 0 : (positive / total * 100);
        final negPct = total == 0 ? 0 : (negative / total * 100);
        final neutralPct = total == 0 ? 0 : (neutral / total * 100);
        var favTags = '';
        for (final tag in user!.tagsFrequency.getTopTags()) {
          favTags = '$favTags#$tag, ';
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              sectionTitle: 'Your Stats',
              fontSize: 16,
              seeAll: false,
              onSeeAll: () {},
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white,
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
                      '${context.currentUser?.totalEntries ?? 0}',
                    ),
                    const Divider(),
                    _statItem(
                      'Mood Trends',
                      'Positive: ${posPct.toStringAsFixed(0)}%, '
                          'Neutral: ${neutralPct.toStringAsFixed(0)}%, '
                          'Negative: ${negPct.toStringAsFixed(0)}%',
                    ),
                    const Divider(),
                    _statItem(
                      'Favorite Tags',
                      favTags,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SectionHeader(
              sectionTitle: 'Settings',
              fontSize: 16,
              seeAll: false,
              onSeeAll: () {},
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
                          // color: Colours.softGreyColor,
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
                    // color: Colours.softGreyColor,
                  ),
                ),
              ),
            ],
          );
  }

  Widget _settingsItem(BuildContext context, String title, IconData icon) {
    return Card(
      color: Colors.white,
      child: ListTile(
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
        trailing: title == 'Sign Out'
            ? null
            : const Icon(
                Icons.keyboard_arrow_right,
              ),
        onTap: () async {
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
      ),
    );
  }
}
