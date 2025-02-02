import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/features/profile/presentation/refactors/profile_body.dart';
import 'package:mental_health_journal_app/features/profile/presentation/refactors/profile_header.dart';
import 'package:mental_health_journal_app/features/profile/presentation/views/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.backgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colours.backgroundColor,
        backgroundColor: Colours.backgroundColor,
        title: const Text('My Profile'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditProfileScreen.id);
            },
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
