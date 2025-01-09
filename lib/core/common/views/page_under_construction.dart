import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/core/resources/strings.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.backgroundColor,
      appBar: AppBar(),
      body: Center(
        child: Text(
          Strings.pageNotFoundText,
          style: context.theme.textTheme.bodyLarge,
        ),
      ),
    );
  }
}
