import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_journal_app/core/common/views/long_button.dart';
import 'package:mental_health_journal_app/core/enums/update_user_action.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/core/utils/core_utils.dart';
import 'package:mental_health_journal_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:mental_health_journal_app/features/profile/presentation/widget/edit_profile_form.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  static const String id = '/editProfileScreen';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();

  final emailController = TextEditingController();

  File? pickedImage;

  bool get nameChanged => context.currentUser?.name.trim() != nameController.text.trim();

  bool get emailChanged => emailController.text.trim().isNotEmpty;

  bool get imageChanged => pickedImage != null;

  bool get nothingChanged => !nameChanged && !emailChanged && !imageChanged;

  Future<void> showImagePickerOptions(BuildContext context) async {
    final image = await CoreUtils.pickImageFromGallery();
    if (image != null) {
      setState(() {
        pickedImage = image;
      });
    }
  }

  @override
  void initState() {
    nameController.text = context.currentUser!.name.trim();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void saveChanges(BuildContext context) {
    if (nothingChanged) Navigator.pop(context);
    final bloc = context.read<AuthBloc>();
    if (nameChanged) {
      bloc.add(
        UpdateUserEvent(
          action: UpdateUserAction.name,
          userData: nameController.text.trim(),
        ),
      );
    }
    if (emailChanged) {
      bloc.add(
        UpdateUserEvent(
          action: UpdateUserAction.email,
          userData: emailController.text.trim(),
        ),
      );
    }
    if (imageChanged) {
      bloc.add(
        UpdateUserEvent(
          action: UpdateUserAction.profilePictureUrl,
          userData: pickedImage,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UserUpdated) {
          Navigator.popUntil(
            context,
            ModalRoute.withName('/'),
          );
          CoreUtils.showSnackBar(
            context,
            'Profile updated successfully',
          );
          // context.pop();
        } else if (state is AuthError) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          // backgroundColor: Colors.white,
          appBar: AppBar(
            // surfaceTintColor: Colors.white,
            title: const Text('Edit Profile'),
          ),
          body: Container(
            constraints: const BoxConstraints.expand(),
            child: SafeArea(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Builder(
                    builder: (context) {
                      final user = context.currentUser!;
                      final userImage = user.profilePictureUrl == null || user.profilePictureUrl!.isEmpty
                          ? null
                          : user.profilePictureUrl;
                      return Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          const SizedBox(height: 25),
                          Container(
                            height: context.height * 0.2,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              // color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: pickedImage != null
                                ? Image.file(
                                    pickedImage!,
                                    fit: BoxFit.contain,
                                  )
                                : userImage != null
                                    ? Image.network(
                                        userImage,
                                        fit: BoxFit.contain,
                                      )
                                    : const Center(
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                          size: 150,
                                        ),
                                      ),
                          ),
                          Positioned(
                            child: Container(
                              height: context.height * 0.2,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colours.softGreyColor.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async => showImagePickerOptions(
                              context,
                            ),
                            icon: Icon(
                              (pickedImage != null || user.profilePictureUrl != null)
                                  ? Icons.edit
                                  : Icons.add_a_photo,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  EditProfileForm(
                    nameController: nameController,
                    emailController: emailController,
                  ),
                  const SizedBox(height: 30),
                  StatefulBuilder(
                    builder: (context, refresh) {
                      nameController.addListener(() => refresh(() {}));
                      emailController.addListener(() => refresh(() {}));
                      return state is AuthLoading
                          ? const Center(child: CircularProgressIndicator())
                          : LongButton(
                              onPressed: nothingChanged
                                  ? null
                                  : () => saveChanges(
                                        context,
                                      ),
                              label: 'Save',
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
