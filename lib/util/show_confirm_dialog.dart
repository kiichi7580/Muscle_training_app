import 'package:flutter/material.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';

Future<void> showConfirmDialog(
  BuildContext context,
  dynamic snap,
  dynamic function,
) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('削除の確認'),
        content: const Text('本当に削除しますか？'),
        actions: [
          TextButton(
            child: const Text('いいえ'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('はい'),
            onPressed: () async {
              //タイマーを削除
              String res = await function(snap['id']);
              if (res == 'success') {
                String res = '削除しました';
                showSnackBar(res, context, backgroundColor: Colors.red);
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
