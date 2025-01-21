import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';

class LongButton extends StatelessWidget {
  const LongButton({
    required this.onPressed,
    required this.label,
    this.backgroundColor,
    this.textColor,
    super.key,
  });

  final void Function()? onPressed;
  final String label;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      height: 50,
      color: backgroundColor ?? Theme.of(context).primaryColor,
      disabledColor: Colours.softGreyColor,
      disabledTextColor: Colors.white,
      disabledElevation: 0,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: textColor ?? Colors.white,
        ),
      ),
    );
  }
}
