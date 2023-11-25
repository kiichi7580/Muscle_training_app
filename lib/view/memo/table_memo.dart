import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:muscle_training_app/view/memo/add_memo.dart';
import 'package:muscle_training_app/view_model/memo_model/memo_model.dart';
import 'package:muscle_training_app/view/memo/edit_memo.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:muscle_training_app/view_model/memo_model/table_memo_model.dart';
import 'package:provider/provider.dart';
import 'package:muscle_training_app/domain/memo.dart';
// import '../login/login_page.dart';

class TableWidget extends StatelessWidget {
  TableWidget({
    super.key,
    required this.date,
  });
  final String date;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TableMemoModel>(
      create: (_) => TableMemoModel()..fetchTableMemo(date),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('メニュー'),
          // actions: [
          //   IconButton(
          //     onPressed: () async {
          //       await Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => LoginPage(),
          //           fullscreenDialog: true,
          //         ),
          //       );
          //     },
          //     icon: Icon(Icons.person),
          //   ),
          // ],
        ),
        body: Center(
          child: Consumer<TableMemoModel>(builder: (context, model, child) {
            final List<Memo>? memos = model.memos;

            if (memos == null) {
              return CircularProgressIndicator();
            }

            final List<Widget> widgets = memos.map((memo) {
              return Slidable(
                // child: Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: DataTable(
                //     columns: [
                //       DataColumn(
                //           label: Text('種目', textAlign: TextAlign.center)),
                //       DataColumn(
                //           label: Text('重量', textAlign: TextAlign.center)),
                //       DataColumn(
                //           label: Text('セット', textAlign: TextAlign.center)),
                //       DataColumn(
                //           label: Text('回数', textAlign: TextAlign.center)),
                //     ],
                //     rows: memos.map((data) {
                //       return DataRow(
                //         cells: [
                //           DataCell(
                //               Text(memo.event, textAlign: TextAlign.center)),
                //           DataCell(Text(
                //               memo.weight != null
                //                   ? memo.weight.toString()
                //                   : '-',
                //               textAlign: TextAlign.center)),
                //           DataCell(Text(
                //               memo.set != null ? memo.set.toString() : '-',
                //               textAlign: TextAlign.center)),
                //           DataCell(Text(
                //               memo.rep != null ? memo.rep.toString() : '-',
                //               textAlign: TextAlign.center)),
                //         ],
                //       );
                //     }).toList(),
                //   ),
                // ),

                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Table(
                            children: <TableRow>[
                              TableRow(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      memo.event,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      memo.weight + 'kg',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      memo.set + 'set',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      memo.rep + 'rep',
                                      style: TextStyle(fontSize: 15),
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

                endActionPane: ActionPane(
                  motion: ScrollMotion(),
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
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        model.fetchTableMemo(date);
                      },
                      backgroundColor: Colors.black45,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: '編集',
                    ),
                    SlidableAction(
                      onPressed: (BuildContext context) async {
                        //削除しますか？って聞いて、はいだったら削除
                        await showConfirmDialog(context, memo, model);
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: '削除',
                    ),
                  ],
                ),
              );
            }).toList();
            return ListView(
              children: widgets,
            );
          }),
        ),
        floatingActionButton:
            Consumer<TableMemoModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              //画面遷移
              final bool? added = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMemoPage(),
                  fullscreenDialog: true,
                ),
              );

              if (added != null && added) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('メモを追加しました'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              model.fetchTableMemo(date);
            },
            tooltip: 'メモを追加する',
            child: Icon(Icons.add),
          );
        }),
      ),
    );
  }

  Future showConfirmDialog(
    BuildContext context,
    Memo memo,
    TableMemoModel model,
  ) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("削除の確認"),
            content: Text("『${memo.event}』を削除しますか？"),
            actions: [
              TextButton(
                  child: Text("いいえ"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                child: Text("はい"),
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
        });
  }
}
