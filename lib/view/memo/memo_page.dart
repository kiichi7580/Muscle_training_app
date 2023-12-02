import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/domain/memo.dart';
import 'package:muscle_training_app/view/memo/add_memo.dart';
import 'package:muscle_training_app/view/memo/table_memo.dart';
import 'package:muscle_training_app/view_model/memo_model/memo_model.dart';
import 'package:provider/provider.dart';

class MemoPage extends StatelessWidget {
  const MemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MemoModel>(
      create: (_) => MemoModel()..fetchMemo(),
      child: Scaffold(
        backgroundColor: mainColor,
        body: Center(
          child: Consumer<MemoModel>(
            builder: (context, model, child) {
              final List<dynamic>? memos = model.memos;

              if (memos == null) {
                return const CircularProgressIndicator();
              }

              final List<Widget> widgets = memos.map((memo) {
                return Padding(
                  padding: const EdgeInsets.all(6),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.check_circle),
                      dense: true,
                      tileColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      title: Text(
                        memo.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) =>
                                TableWidget(date: memo.toString()),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }).toList();
              return ListView(
                children: widgets,
              );
            },
          ),
        ),
        floatingActionButton: Consumer<MemoModel>(
          builder: (context, model, child) {
            return FloatingActionButton(
              onPressed: () async {
                //画面遷移
                final bool? added = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddMemoPage(),
                    fullscreenDialog: true,
                  ),
                );

                if (added != null && added) {
                  const snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('メモを追加しました'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                model.fetchMemo();
              },
              tooltip: 'メモを追加する',
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }

  Future<void> showConfirmDialog(
    BuildContext context,
    Memo memo,
    MemoModel model,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('削除の確認'),
          content: Text('$memoのメニューを削除しますか？'),
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
                //modelで削除
                await model.delete(memo);
                Navigator.pop(context);
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('$memoのメニューを削除しました'),
                );
                await model.fetchMemo();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }
}
