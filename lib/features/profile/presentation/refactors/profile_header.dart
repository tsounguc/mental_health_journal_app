import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/common/app/providers/user_provider.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/features/profile/presentation/views/edit_profile_screen.dart';
import 'package:mental_health_journal_app/features/profile/presentation/views/profile_picture_screen.dart';
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
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ProfilePictureScreen.id);
              },
              child: Hero(
                tag: 'profilePic',
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colours.softGreyColor.withValues(alpha: 0.3),
                  backgroundImage: imageIsNull
                      ? null
                      : NetworkImage(
                          image!,
                        ),
                  child: imageIsNull
                      ? const Icon(
                          Icons.person,
                          color: Colours.softGreyColor,
                          size: 125,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              user?.name ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user?.email ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Colours.softGreyColor,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
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
