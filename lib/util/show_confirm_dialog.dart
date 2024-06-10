// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';

Future<void> showDeleteConfirmDialog(
  BuildContext context,
  dynamic snap,
  dynamic function,
) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: mainColor,
        title: const Text('削除の確認'),
        content: const Text('本当に削除しますか？'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: deleteColor,
            ),
            child: const Text('はい'),
            onPressed: () async {
              // データ削除
              String res = await function(snap);
              if (res == successRes) {
                String res = successDelete;
                showSnackBar(res, context, backgroundColor: deleteColor);
              }
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: blackColor,
            ),
            child: const Text('いいえ'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
