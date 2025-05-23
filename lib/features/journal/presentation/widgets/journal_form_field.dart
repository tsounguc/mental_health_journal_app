import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/common/widgets/i_field.dart';

class JournalFormField extends StatelessWidget {
  const JournalFormField({
    this.controller,
    this.prefix,
    this.prefixIcon,
    this.fieldTitle,
    this.textInputAction = TextInputAction.next,
    this.hintText,
    this.hintStyle,
    this.borderRadius,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.onFieldSubmitted,
    this.fillColor,
    this.filled = false,
    super.key,
  });

  final Widget? prefix;
  final Widget? prefixIcon;
  final String? fieldTitle;
  final TextEditingController? controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final bool readOnly;
  final BorderRadius? borderRadius;
  final int? maxLines;
  final int? minLines;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final Color? fillColor;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fieldTitle != null)
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              fieldTitle!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        const SizedBox(height: 10),
        IField(
          controller: controller ?? TextEditingController(),
          fillColor: fillColor,
          filled: filled,
          prefix: prefix,
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: hintStyle,
          readOnly: readOnly,
          borderRadius: borderRadius,
          maxLines: maxLines,
          minLines: minLines,
          onFieldSubmitted: onFieldSubmitted,
          textInputAction: textInputAction,
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
