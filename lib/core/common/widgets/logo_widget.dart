import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mental_health_journal_app/core/resources/strings.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    this.size = 35,
    this.fontSize = 42,
    this.showText = true,
    this.color,
    super.key,
  });
  final double size;
  final double fontSize;
  final bool showText;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: size,
              color: color,
            ),
            Icon(
              IconlyLight.edit,
              size: size,
              color: color,
            ),
          ],
        ),
        if (showText)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Strings.logoText,
                style: TextStyle(
                  fontSize: fontSize,
                  color: color,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
