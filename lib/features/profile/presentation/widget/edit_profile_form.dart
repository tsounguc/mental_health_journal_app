import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/extensions/string_extensions.dart';
import 'package:mental_health_journal_app/features/profile/presentation/widget/edit_profile_form_field.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({
    required this.nameController,
    required this.emailController,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditProfileFormField(
          fieldTitle: 'Name',
          controller: nameController,
          hintText: context.currentUser!.name,
        ),
        EditProfileFormField(
          fieldTitle: 'Email',
          controller: emailController,
          hintText: context.currentUser!.email.obscureEmail,
        ),
      ],
    );
  }
}
