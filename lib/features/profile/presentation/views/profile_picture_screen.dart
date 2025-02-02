import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/features/auth/presentation/auth_bloc/auth_bloc.dart';

class ProfilePictureScreen extends StatelessWidget {
  const ProfilePictureScreen({super.key});

  static const String id = '/profile-picture';

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;
    final imageIsNull = user?.profilePictureUrl == null;
    final imageIsEmpty = user?.profilePictureUrl?.isEmpty ?? false;
    final image = imageIsNull || imageIsEmpty ? null : user?.profilePictureUrl;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // if (state is ProfilePicDeleted) {
        //   CoreUtils.showSnackBar(context, 'Profile picture deleted');
        //   Navigator.pop(context);
        // }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          actions: [
            if (!imageIsNull && !imageIsEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton(
                  onPressed: () {
                    // context.read<AuthBloc>().add(DeleteProfilePicEvent(user: user));
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      // fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
          ],
        ),
        body: Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 150),
          child: Center(
            child: Hero(
              tag: 'profilePic',
              child: image != null
                  ? Image.network(
                      image,
                      fit: BoxFit.cover,
                    )
                  : const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 150),
                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 400,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
