import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/features/profile/presentation/refactors/profile_body.dart';
import 'package:mental_health_journal_app/features/profile/presentation/refactors/profile_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: context.theme.scaffoldBackgroundColor,
        title: const Text('My Profile'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        children: const [
          ProfileHeader(),
          SizedBox(height: 32),
          ProfileBody(),
        ],
      ),
    );
  }
}
