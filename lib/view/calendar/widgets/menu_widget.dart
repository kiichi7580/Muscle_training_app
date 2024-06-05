// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:muscle_training_app/domain/memo.dart';
import 'package:muscle_training_app/models/memo_model/detail_memo_model.dart';
import 'package:muscle_training_app/view/memo/widgets/table_memo_widget.dart';

Widget MenuWidget(
  BuildContext context,
  String date,
) {
  int dateId = DetailMemoModel().dateToDateId(date);
  return ChangeNotifierProvider<DetailMemoModel>(
    create: (_) => DetailMemoModel()..fetchTableMemo(dateId),
    child: Scaffold(
      body: Center(
        child: Consumer<DetailMemoModel>(
          builder: (context, model, child) {
            final List<Memo>? memos = model.memos;

            if (memos == null) {
              return const CircularProgressIndicator();
            }

            if (memos.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 150,
                  ),
                  child: Text(
                    'メニューがありません',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }
            return TableMemoWidget(memos: memos);
          },
        ),
      ),
    ),
  );
}
