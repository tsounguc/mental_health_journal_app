import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mental_health_journal_app/core/common/widgets/enter_password_dialog.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/core/services/service_locator.dart';
import 'package:mental_health_journal_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';

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

  static Future<void> displayDeleteAccountWarning(
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

  static Future<void> showEnterPasswordDialog(BuildContext context) async {
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
  }

  /// Generates a list of weekdays starting from
  /// today (e.g., If today is Wed, list starts at 'Wed')
  static List<String> generateRotatedWeekLabels() {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final todayIndex = DateTime.now().weekday; // Convert to zero-based index
    return [
      ...weekdays.sublist(todayIndex),
      ...weekdays.sublist(0, todayIndex),
    ];
  }

  static List<String> generateRotatedYearLabels() {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final todayIndex = DateTime.now().month; // Convert to zero-based index
    return [
      ...months.sublist(todayIndex),
      ...months.sublist(0, todayIndex),
    ];
  }

  static List<String> generateMoodInsights(List<JournalEntry> entries, String selectedFilter) {
    final insights = <String>[];
    final moods = ['happy', 'sad', 'angry'];
    final moodCounts = {
      'happy': 0,
      'neutral': 0,
      'sad': 0,
      'angry': 0,
    };
    final consecutiveMoodDays = {
      'happy': 0,
      'neutral': 0,
      'sad': 0,
      'angry': 0,
    };
    String? prevMood;

    var sentimentSum = 0.0;

    for (final entry in entries) {
      final entryMood = entry.selectedMood.toLowerCase();

      if (moodCounts.containsKey(entryMood)) {
        moodCounts[entryMood] = moodCounts[entryMood]! + 1;
      }
      for (final mood in moods) {
        if (entryMood == mood) {
          consecutiveMoodDays[entryMood] = (prevMood == mood) ? consecutiveMoodDays[entryMood]! + 1 : 1;
        } else {
          if (consecutiveMoodDays[mood]! >= 3) {
            insights.add("You've been $mood for "
                '${consecutiveMoodDays[mood]} days in a row!');
          }
          consecutiveMoodDays[entryMood] = 0;
        }
      }
      sentimentSum += entry.sentimentScore;
      prevMood = entryMood;
    }
    final averageSentiment = sentimentSum / entries.length;

    for (final mood in moods) {
      if (moodCounts[mood]! >= 1) {
        insights.add('You’ve been $mood ${moodCounts[mood]} '
            'times this ${selectedFilter.toLowerCase()}.');
      }
      if (consecutiveMoodDays[mood]! >= 3) {
        insights.add("You've been $mood for "
            '${consecutiveMoodDays[mood]} days in a row!');
      }
    }

    if (averageSentiment > 0.1) {
      insights.add('Overall, your sentiment has been quite positive lately!');
    } else if (averageSentiment < -0.1) {
      insights.add("It looks like you've been feeling more negative recently.");
    } else {
      insights.add('Your overall sentiment has been relatively neutral.');
    }

    return insights;
  }

  /// Maps user-selected moods to numerical values for the graph
  static int mapMoodToValue(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return 5;
      case 'neutral':
        return 4;
      case 'sad':
        return 3;
      case 'angry':
        return 2;
      default:
        return 4; // Default to neutral
    }
  }
}
