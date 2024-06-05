// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';

class EditOrDeleteConfirmDialog extends StatelessWidget {
  const EditOrDeleteConfirmDialog({
    Key? key,
    required this.memo,
  });
  final dynamic memo;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: mainColor,
      title: Row(
        children: [
          Text(
            '「${memo['event']}」',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'のメニューを',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
      children: [
        SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SimpleDialogOption(
              child: Text(
                editTx,
                style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, editTx);
              },
            ),
            SimpleDialogOption(
              child: Text(
                deleteTx,
                style: TextStyle(
                  color: deleteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, deleteTx);
              },
            )
          ],
        )
      ],
    );
  }
}
