// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:muscle_training_app/constant/colors.dart';

showSnackBar(
  String content,
  BuildContext context, {
  Color? backgroundColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor ?? blackColor,
      content: Text(content),
    ),
  );
}
