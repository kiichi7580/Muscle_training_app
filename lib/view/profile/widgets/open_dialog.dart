// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:muscle_training_app/constant/text_resorce.dart';

Future<void> imageDialog(BuildContext context, String imageUrl) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: imageUrl == defaultPhotoUrlString
            ? Image.asset(
                imageUrl,
                fit: BoxFit.cover,
              )
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
      );
    },
  );
}
