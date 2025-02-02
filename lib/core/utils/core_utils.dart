import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mental_health_journal_app/core/common/widgets/enter_password_dialog.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/core/services/service_locator.dart';
import 'package:mental_health_journal_app/features/auth/presentation/auth_bloc/auth_bloc.dart';

class CoreUtils {
  const CoreUtils._();

  static void showSnackBar(
    BuildContext context,
    String message, {
    int durationInMilliSecond = 3000,
  }) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: Duration(milliseconds: durationInMilliSecond),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
          ).copyWith(bottom: context.height * 0.85),
        ),
      );
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => Center(
        child: CircularProgressIndicator(
          backgroundColor: context.theme.scaffoldBackgroundColor,
        ),
      ),
    );
  }

  static void displayDeleteAccountWarning(
    BuildContext context, {
    void Function()? onDeletePressed,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // backgroundColor: Colors.yellow[600],
          backgroundColor: context.theme.cardTheme.color,
          surfaceTintColor: context.theme.cardTheme.color,
          title: Text(
            'WARNING',
            style: context.theme.textTheme.titleMedium,
          ),
          content: Text(
            'Are you sure you want to delete this account?',
            style: context.theme.textTheme.bodyMedium,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'CANCEL',
                style: context.theme.textTheme.bodyMedium,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              onPressed: onDeletePressed,
              child: Text(
                'DELETE ACCOUNT',
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showEnterPasswordDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: serviceLocator<AuthBloc>(),
          child: const EnterPasswordDialog(),
        );
      },
    );
  }

  static Future<File?> pickImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  static Future<List<XFile>?> pickImagesFromGallery() async {
    final selectedImages = await ImagePicker().pickMultiImage();
    if (selectedImages.isNotEmpty) {
      return selectedImages;
    }
    return null;
  }

  static Future<File?> getImageFromCamera() async {
    final picker = ImagePicker();
    if (picker.supportsImageSource(ImageSource.camera)) {
      final image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        return File(image.path);
      }
      return null;
    }
    return null;
  }

  static Color getMoodColor(String mood) {
    switch (mood) {
      case 'Happy':
        return Colours.positiveMoodColor;
      case 'Neutral':
        return Colours.neutralMoodColor;
      case 'Angry':
        return Colours.negativeMoodColor;
      case 'Sad':
        return Colours.secondaryColor;
      default:
        return Colours.softGreyColor;
    }
  }

  static String getEmoji(String mood) {
    switch (mood) {
      case 'Happy':
        return '😊';
      case 'Neutral':
        return '😐';
      case 'Angry':
        return '😠';
      case 'Sad':
        return '😢';
      default:
        return '';
    }
  }

  static Color getSentimentColor(double sentimentScore) {
    if (sentimentScore > 0.1) {
      return Colours.positiveMoodColor;
    } else if (sentimentScore < -0.1) {
      return Colours.negativeMoodColor;
    } else {
      return Colours.neutralMoodColor;
    }
    //   switch (sentimentScore) {
    //     case sentimentScore > 0.6:
    //       return Colours.positiveMoodColor;
    //     case 'Neutral':
    //       return Colours.neutralMoodColor;
    //     case 'Angry':
    //       return Colours.negativeMoodColor;
    //     case 'Sad':
    //       return Colours.secondaryColor;
    //     default:
    //       return Colours.softGreyColor;
    //   }
  }
}
