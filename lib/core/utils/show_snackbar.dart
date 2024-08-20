import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  required String message,
  required Color color,
  Duration? duration,
}) {
  ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: duration ?? const Duration(seconds: 4),
    ),
  );
}