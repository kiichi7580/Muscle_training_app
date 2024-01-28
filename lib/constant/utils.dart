import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';

showSnackbar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: blackColor,
      content: Text(content),
    ),
  );
}
