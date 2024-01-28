import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/domain/memo.dart';
import 'package:muscle_training_app/view/memo/add_memo.dart';
import 'package:muscle_training_app/view/memo/edit_memo.dart';
import 'package:muscle_training_app/view_model/memo_model/table_memo_model.dart';
import 'package:provider/provider.dart';

class TableWidget extends StatelessWidget {
  const TableWidget({
    super.key,
    required this.date,
  });
  final String date;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TableMemoModel>(
      create: (_) => TableMemoModel()..fetchTableMemo(date),
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          title: const Text(
            'メニュー',
            style: TextStyle(color: blackColor),
          ),
          backgroundColor: blueColor,
        ),
        body: Center(
          child: Consumer<TableMemoModel>(
            builder: (context, model, child) {
              final List<Memo>? memos = model.memos;

              if (memos == null) {
                return const CircularProgressIndicator();
              }

              final List<Widget> widgets = memos.map((memo) {
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        // An action can be bigger than the others.
                        onPressed: (BuildContext context) async {
                          //編集画面に遷移
                          final String? event = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditMemoPage(memo),
                            ),
                          );

                          if (event != null) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('$eventを編集しました'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                          model.fetchTableMemo(date);
                        },
                        backgroundColor: Colors.black45,
                        foregroundColor: mainColor,
                        icon: Icons.edit,
                        label: '編集',
                      ),
                      SlidableAction(
                        onPressed: (BuildContext context) async {
                          //削除しますか？って聞いて、はいだったら削除
                          await showConfirmDialog(context, memo, model);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: mainColor,
                        icon: Icons.delete,
                        label: '削除',
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Table(
                              defaultColumnWidth: const IntrinsicColumnWidth(),
                              children: <TableRow>[
                                TableRow(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        memo.event,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        '${memo.weight}kg',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        '${memo.set}set',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        '${memo.rep}rep',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
        floatingActionButton: Consumer<TableMemoModel>(
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
                model.fetchTableMemo(date);
              },
              tooltip: 'メモを追加する',
              backgroundColor: Colors.lightBlueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> showConfirmDialog(
    BuildContext context,
    Memo memo,
    TableMemoModel model,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('削除の確認'),
          content: Text('『${memo.event}』のメニューを削除しますか？'),
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
                  content: Text('${memo.event}を削除しました'),
                );
                model.fetchTableMemo(date);
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }
}
