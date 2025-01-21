import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/common/app/providers/user_provider.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/features/profile/presentation/views/edit_profile_screen.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        final user = provider.user;
        final imageIsNull = user?.profilePictureUrl == null;
        final imageIsEmpty = user?.profilePictureUrl?.isEmpty ?? false;
        final image = imageIsNull || imageIsEmpty ? null : user?.profilePictureUrl;
        return Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colours.softGreyColor,
              backgroundImage: imageIsNull
                  ? null
                  : NetworkImage(
                      image!,
                    ),
              child: imageIsNull
                  ? const Icon(
                      Icons.person,
                      size: 75,
                    )
                  : null,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              user?.name ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user?.email ?? '',
              style: const TextStyle(
                fontSize: 16,
                color: Colours.softGreyColor,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO(Profile-Screen): Handle edit profile action
                Navigator.pushNamed(context, EditProfileScreen.id);
              },
              child: const Text('Edit Profile'),
            ),
          ],
        );
      },
    );
  }
}
