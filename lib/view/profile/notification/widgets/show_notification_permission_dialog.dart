import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/widgets/custom_dialog.dart';

Future<bool?> showNotificationPermissionDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: _buildNotificationPermissionDialog,
  );
}

Widget _buildNotificationPermissionDialog(BuildContext context) {
  return CustomDialog(
    title: 'プッシュ通知の送信',
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 40),
    content: const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            Text(
              'MMから通知を送信してもよろしいですか？',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(height: 24),
        Column(
          children: [
            // Text(
            //   '通知方法は、テキスト、サウンド、アイコンバッジ',
            //   textAlign: TextAlign.center,
            // ),
            // Text(
            //   'が利用できる可能性があります。',
            //   textAlign: TextAlign.center,
            // ),
            Text(
              'この設定は、設定画面からいつでも変更できます。',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    ),
    actions: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          foregroundColor: heavyBlueColor,
          backgroundColor: mainColor,
        ),
        onPressed: () {
          Navigator.pop(context, false);
        },
        child: Text(
          'あとで',
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          foregroundColor: mainColor,
          backgroundColor: heavyBlueColor,
        ),
        onPressed: () {
          Navigator.pop(context, true);
        },
        child: Text(
          'はい',
        ),
      ),
    ],
  );
}
