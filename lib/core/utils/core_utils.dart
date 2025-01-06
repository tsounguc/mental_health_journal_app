import 'package:flutter/material.dart';

class CoreUtils {
  const CoreUtils._();

  static void showSnackBar(
    BuildContext context,
    String message,
  ) =>
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            dismissDirection: DismissDirection.up,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 150,
              left: 10,
              right: 10,
            ),
            content: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
}
