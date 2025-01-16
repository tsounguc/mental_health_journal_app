import 'package:flutter/material.dart';

class NoEntriesWidget extends StatelessWidget {
  const NoEntriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Text(
            'No Journal Entries',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
