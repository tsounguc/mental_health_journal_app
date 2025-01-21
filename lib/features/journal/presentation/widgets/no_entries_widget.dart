import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';

class NoEntriesWidget extends StatelessWidget {
  const NoEntriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No entries yet.'
            '\nCreate an entry and start writing',
            style: TextStyle(fontSize: 16, color: Colours.softGreyColor),
          ),
        ],
      ),
    );
  }
}
